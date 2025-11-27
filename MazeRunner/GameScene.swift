//
//  GameScene.swift
//  MazeRunner
//
//  Created by Admin on 25/11/25.
//

import SpriteKit

class GameScene: SKScene {
    
    private let config: MazeConfig
    private let mazeContainer = SKNode()
    private var player = SKSpriteNode()
    
    private var lastTouchLocation: CGPoint?
    private var isMovementAllowed: Bool = false
    
    var giftTimer: TimeInterval = 0
    
    var WALL_SIZE: CGFloat = 50.0
    
    init(size: CGSize, config: MazeConfig) {
        self.config = config
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        WALL_SIZE = calculateOptimalWallSize()
        
        let bg = SKSpriteNode(imageNamed: config.floorTextureName)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = -1
        bg.size = size
        addChild(bg)
        
        addChild(mazeContainer)
        createLevel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        giftTimer += 1/60
        
        if giftTimer >= 1.0 {
            giftTimer = 0
            for node in mazeContainer.children where node is GiftNode {
                let gift = node as! GiftNode
                gift.tick()
                if gift.remainingTime <= 0 {
                    gift.removeFromParent()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: mazeContainer)
        if isWall(at: location) { return }
        
        lastTouchLocation = location
        isMovementAllowed = true
        startWalkAnimation()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isMovementAllowed, let touch = touches.first else { return }
        
        let location = touch.location(in: mazeContainer)
        
        if isWall(at: location) {
            stopWalkAnimation()
            player.physicsBody?.velocity = .zero
            isMovementAllowed = false
            return
        }
        
        lastTouchLocation = location
        applyMovementToward(location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMovementAllowed = false
        player.physicsBody?.velocity = .zero
        stopWalkAnimation()
    }
    
    private func applyMovementToward(_ location: CGPoint) {
        
        let dx = location.x - player.position.x
        let dy = location.y - player.position.y
        let distance = sqrt(dx*dx + dy*dy)
        
        // Avoid division by zero
        guard distance > 4 else {
            player.physicsBody?.velocity = .zero
            stopWalkAnimation()
            return
        }
        
        // Normalize movement vector
        let ux = dx / distance
        let uy = dy / distance
        
        // Apply fixed-speed velocity
        let vx = ux * config.playerSpeed
        let vy = uy * config.playerSpeed
        
        player.physicsBody?.velocity = CGVector(dx: vx, dy: vy)
        
        // Flip sprite direction
        player.xScale = ux >= 0 ? abs(player.xScale) : -abs(player.xScale)
        
        startWalkAnimation()
    }
    
}

extension GameScene {
    
    private func startWalkAnimation() {
        if player.action(forKey: "walk") != nil { return }
        
        let textures = (1...16).map { SKTexture(imageNamed: "run\($0)") }
        let act = SKAction.repeatForever(.animate(with: textures, timePerFrame: 0.08))
        player.run(act, withKey: "walk")
    }
    
    private func stopWalkAnimation() {
        player.removeAction(forKey: "walk")
    }
    
    private func createLevel() {
        
        let totalWidth = CGFloat(config.map_cols) * WALL_SIZE
        let totalHeight = CGFloat(config.map_rows) * WALL_SIZE
        
        mazeContainer.position = CGPoint(
            x: (size.width - totalWidth)/2,
            y: (size.height - totalHeight)/2
        )
        
        mazeContainer.physicsBody = SKPhysicsBody(
            edgeLoopFrom: CGRect(x: 0, y: 0,
                                 width: totalWidth,
                                 height: totalHeight)
        )
        mazeContainer.physicsBody?.isDynamic = false
        mazeContainer.physicsBody?.categoryBitMask = PhysicsCategory.wall
        mazeContainer.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        let wallTex = SKTexture(imageNamed: config.wallTextureName)
        let exitTex = SKTexture(imageNamed: config.exitTextureName)
        
        var giftTime = 5
        
        for (row, cols) in config.map.enumerated() {
            for (col, value) in cols.enumerated() {
                
                let pos = CGPoint(
                    x: CGFloat(col) * WALL_SIZE + WALL_SIZE/2,
                    y: (CGFloat(config.map_rows - 1 - row)) * WALL_SIZE + WALL_SIZE/2
                )
                
                let cellSize = CGSize(width: WALL_SIZE, height: WALL_SIZE)
                var node: SKNode?
                
                switch value {
                    
                case 1:
                    let wall = SKSpriteNode(texture: wallTex, size: cellSize)
                    wall.name = "wall"
                    wall.physicsBody = SKPhysicsBody(rectangleOf: cellSize)
                    wall.physicsBody?.isDynamic = false
                    wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
                    node = wall
                case 2:
                    player = SKSpriteNode(imageNamed: "\(config.playerTexturePrefix)1")
                    player.size = cellSize
                    player.position = pos
                    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: cellSize)
                    player.physicsBody?.allowsRotation = false
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.linearDamping = 5
                    player.physicsBody?.categoryBitMask = PhysicsCategory.player
                    player.physicsBody?.collisionBitMask = PhysicsCategory.wall
                    player.physicsBody?.contactTestBitMask = PhysicsCategory.exit | PhysicsCategory.gift
                    node = player
                case 3:
                    let exit = SKSpriteNode(texture: exitTex, size: cellSize)
                    exit.name = "exit"
                    exit.physicsBody = SKPhysicsBody(rectangleOf: cellSize)
                    exit.physicsBody?.isDynamic = false
                    exit.physicsBody?.categoryBitMask = PhysicsCategory.exit
                    node = exit
                case 4:
                    let gift = GiftNode()
                    gift.position = pos
                    gift.name = "gift"
                    gift.remainingTime = giftTime
                    giftTime += 5
                    node = gift
                default: break
                }
                
                if let n = node {
                    n.position = pos
                    mazeContainer.addChild(n)
                }
            }
        }
    }
    
    private func calculateOptimalWallSize() -> CGFloat {
        let w = size.width / CGFloat(config.map_cols)
        let h = size.height / CGFloat(config.map_rows)
        return max(10, min(w, h) - 2)
    }
    
    private func isWall(at location: CGPoint) -> Bool {
        mazeContainer.nodes(at: location).contains { $0.name == "wall" }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let a = contact.bodyA
        let b = contact.bodyB
        
        let combo = (a.categoryBitMask, b.categoryBitMask)
        
        if combo == (PhysicsCategory.player, PhysicsCategory.exit)
            || combo == (PhysicsCategory.exit, PhysicsCategory.player) {
            
            print("LEVEL EXITED")
        }
        
        if combo == (PhysicsCategory.player, PhysicsCategory.gift)
            || combo == (PhysicsCategory.gift, PhysicsCategory.player) {
            let giftNode = (a.categoryBitMask == PhysicsCategory.gift) ? a.node : b.node
            giftNode?.physicsBody?.categoryBitMask = 0
            giftNode?.physicsBody?.contactTestBitMask = 0
            giftNode?.physicsBody?.collisionBitMask = 0
            
            giftNode?.run(.sequence([
                .wait(forDuration: 0.01),
                .removeFromParent()
            ]))
            
            print("GIFT ACQUIRED")
        }
        
    }
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 1
    static let wall: UInt32 = 2
    static let exit: UInt32 = 4
    static let gift: UInt32 = 8
}
