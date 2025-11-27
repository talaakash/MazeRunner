//
//  GameScene.swift
//  MazeRunner
//
//  Created by Admin on 25/11/25.
//

import SpriteKit

class GameScene: SKScene {
    
    private let player = SKSpriteNode(imageNamed: "run1")
    
    private let playerMovePerSecond: CGFloat = 200
    private var velocity: CGPoint = .zero
    
    private var lastTouchLocation: CGPoint?
    private var isMovementIsValid: Bool = false
    
    var giftTimer: TimeInterval = 0
    
    var WALL_SIZE: CGFloat = 50.0
    let MAP_ROWS = 11
    let MAP_COLS = 17
    let levelMap: [[Int]] = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [2, 0, 0, 4, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 3],
        [1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 4, 0, 1, 0, 1, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1],
        [1, 0, 1, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ]
    let mazeContainer = SKNode()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        
        WALL_SIZE = calculateOptimalWallSize()
        let background = SKSpriteNode(imageNamed: "tile_floor")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
        
        addChild(mazeContainer)
        createLevel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let target = lastTouchLocation else {
            // No target — stop movement
            player.physicsBody?.velocity = .zero
            stopWalkAnimation()
            return
        }
        
        // Compute vector to target
        let offset = target - player.position
        let distance = offset.length()
        
        if distance < 2 {
            player.physicsBody?.velocity = .zero
            velocity = .zero
            stopWalkAnimation()
        } else {
            moveSprite(sprite: player, velocity: velocity)
        }
        
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
        
        let touchLocation = touch.location(in: mazeContainer)
        
        if isWall(at: touchLocation) { return }
        self.isMovementIsValid = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.isMovementIsValid else { return }
        
        let touchLocation = touch.location(in: mazeContainer)
        
        if isWall(at: touchLocation) || (touchLocation.x < 0 || touchLocation.x > (CGFloat(MAP_COLS) * WALL_SIZE)) {
            player.physicsBody?.velocity = .zero
            velocity = .zero
            stopWalkAnimation()
            self.isMovementIsValid = false
            return
        }
        lastTouchLocation = touchLocation
        movePlayerTowards(location: touchLocation)
    }
}

extension GameScene {
    private func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        player.physicsBody?.velocity = CGVector(dx: velocity.x * 0.92, dy: velocity.y * 0.92)
    }
    
    private func movePlayerTowards(location: CGPoint) {
        let offset = CGPoint(x: location.x - player.position.x, y: location.y - player.position.y)
        
        let length = offset.length()
        guard length > 0 else { return }
        
        let direction = CGPoint(x: offset.x / length, y: offset.y / length)
        
        if direction.x > 0 {
            player.xScale = abs(player.xScale)
        } else {
            player.xScale = -abs(player.xScale)
        }
        
        velocity = CGPoint(x: direction.x * playerMovePerSecond, y: direction.y * playerMovePerSecond)
        
        if player.action(forKey: "walk") == nil {
            startWalkAnimation()
        }
    }
    
    private func startWalkAnimation() {
        let textures = [
            SKTexture(imageNamed: "run1"),
            SKTexture(imageNamed: "run2"),
            SKTexture(imageNamed: "run3"),
            SKTexture(imageNamed: "run4"),
            SKTexture(imageNamed: "run5"),
            SKTexture(imageNamed: "run6"),
            SKTexture(imageNamed: "run7"),
            SKTexture(imageNamed: "run8"),
            SKTexture(imageNamed: "run9"),
            SKTexture(imageNamed: "run10"),
            SKTexture(imageNamed: "run11"),
            SKTexture(imageNamed: "run12"),
            SKTexture(imageNamed: "run13"),
            SKTexture(imageNamed: "run14"),
            SKTexture(imageNamed: "run15"),
            SKTexture(imageNamed: "run16"),
        ]
        
        let walkAction = SKAction.animate(with: textures, timePerFrame: 0.08)
        let repeatAction = SKAction.repeatForever(walkAction)
        
        player.run(repeatAction, withKey: "walk")
    }
    
    private func stopWalkAnimation() {
        player.removeAction(forKey: "walk")
    }
    
    private func createLevel() {
        let totalMazeWidth = CGFloat(MAP_COLS) * WALL_SIZE
        let totalMazeHeight = CGFloat(MAP_ROWS) * WALL_SIZE
        
        // Center the container node on the screen
        mazeContainer.position = CGPoint(
            x: (size.width - totalMazeWidth) / 2.0,
            y: (size.height - totalMazeHeight) / 2.0
        )
        
        
        // Get the texture for the wall and path
        let wallTexture = SKTexture(imageNamed: "tile_wall")
        let exitTexture = SKTexture(imageNamed: "joystick_base")
        var giftRemainingTime: Int = 5
        
        // Iterate over the rows (i.e., the y-axis)
        for (row, columnArray) in levelMap.enumerated() {
            
            // Iterate over the columns in the current row (i.e., the x-axis)
            for (col, mapValue) in columnArray.enumerated() {
                
                var node: SKNode? = nil
                let position = CGPoint(
                    x: CGFloat(col) * WALL_SIZE + (WALL_SIZE / 2),
                    y: (CGFloat(MAP_ROWS) - 1 - CGFloat(row)) * WALL_SIZE + (WALL_SIZE / 2)
                )
                
                let size = CGSize(width: WALL_SIZE, height: WALL_SIZE)
                if mapValue == 1 {
                    node = SKSpriteNode(texture: wallTexture, size: size)
                    node?.name = "wall"
                    node?.physicsBody = SKPhysicsBody(rectangleOf: size)
                    node?.physicsBody?.isDynamic = false
                    node?.physicsBody?.categoryBitMask = PhysicsCategory.wall
                    node?.physicsBody?.restitution = 0
                    node?.physicsBody?.friction = 0
                    node?.physicsBody?.allowsRotation = false
                } else if mapValue == 2 {
                    player.size = CGSize(width: WALL_SIZE, height: WALL_SIZE)
                    player.position = position
                    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: size)
                    player.physicsBody?.allowsRotation = false
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.restitution = 0
                    player.physicsBody?.friction = 0
                    player.physicsBody?.linearDamping = 4
                    player.physicsBody?.usesPreciseCollisionDetection = true
                    player.physicsBody?.categoryBitMask = PhysicsCategory.player
                    player.physicsBody?.collisionBitMask = PhysicsCategory.wall
                    player.physicsBody?.contactTestBitMask = PhysicsCategory.exit
                    node = player
                } else if mapValue == 3 {
                    node = SKSpriteNode(texture: exitTexture, size: size)
                    node?.name = "exit"
                    node?.physicsBody = SKPhysicsBody(rectangleOf: size)
                    node?.physicsBody?.isDynamic = false
                    node?.physicsBody?.categoryBitMask = PhysicsCategory.exit
                } else if mapValue == 4 {
                    let gift = GiftNode()
                    gift.position = position
                    gift.name = "gift"
                    gift.remainingTime = giftRemainingTime
                    giftRemainingTime += 5
                    node = gift
                }
                
                if let newNode = node {
                    newNode.position = position
                    mazeContainer.addChild(newNode)
                }
            }
        }
    }
    
    private func calculateOptimalWallSize() -> CGFloat {
        let totalCols = CGFloat(MAP_COLS)
        let totalRows = CGFloat(MAP_ROWS)
        
        let sceneWidth = size.width
        let sceneHeight = size.height
        
        let maxWallSizeByWidth = sceneWidth / totalCols
        let maxWallSizeByHeight = sceneHeight / totalRows
        let optimalSize = min(maxWallSizeByWidth, maxWallSizeByHeight) - 2.0
        return max(10.0, optimalSize)
    }
    
    private func isWall(at location: CGPoint) -> Bool {
        let touchedNodes = mazeContainer.nodes(at: location)
        return touchedNodes.contains(where: { $0.name == "wall" })
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let categories = (bodyA.categoryBitMask, bodyB.categoryBitMask)
        
        // Player reached exit
        if categories == (PhysicsCategory.player, PhysicsCategory.exit) ||
            categories == (PhysicsCategory.exit, PhysicsCategory.player) {
            print("EXIT REACHED — LEVEL COMPLETE")
            return
        }
        
        // Player collects gift
        if categories == (PhysicsCategory.player, PhysicsCategory.gift) ||
            categories == (PhysicsCategory.gift, PhysicsCategory.player) {
            
            let giftNode = (bodyA.categoryBitMask == PhysicsCategory.gift)
            ? bodyA.node
            : bodyB.node
            
            giftNode?.removeFromParent()
            print("GIFT COLLECTED 🎁")
        }
    }
}

struct PhysicsCategory {
    static let none: UInt32  = 0
    static let player: UInt32 = 0b1 // 1
    static let wall: UInt32   = 0b10 // 2
    static let exit: UInt32   = 0b100 // 4
    static let gift: UInt32    = 0b1000
}
