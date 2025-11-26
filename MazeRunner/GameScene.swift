//
//  GameScene.swift
//  MazeRunner
//
//  Created by Admin on 25/11/25.
//

import SpriteKit

class GameScene: SKScene {
    
    private let playableRect: CGRect
    private let player = SKSpriteNode(imageNamed: "run1")
    
    private var lastUpdateTime: TimeInterval = 0.0
    private var dt: TimeInterval = 0.0
    
    private let playerMovePerSecond: CGFloat = 200
    private var velocity: CGPoint = .zero
    
    private var lastTouchLocation: CGPoint?
    
    var WALL_SIZE: CGFloat = 50.0
    let MAP_ROWS = 11
    let MAP_COLS = 17
    let levelMap: [[Int]] = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [2, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 3],
        [1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ]
    let mazeContainer = SKNode()
    
    override init(size: CGSize) {
        let maxAspectRatio = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height / playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
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
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if let lastTouchLocation {
            //            let diffrence = lastTouchLocation - player.position
            //            if (diffrence.length() <= playerMovePerSecond * dt) {
            //                player.position = lastTouchLocation
            //                velocity = .zero
            //            } else {
            //                moveSprite(sprite: player, velocity: velocity)
            //            }
            //            if diffrence.length() <= playerMovePerSecond * dt {
            //                player.position = lastTouchLocation
            //                velocity = .zero
            //                stopWalkAnimation()
            //            } else {
            //                moveSprite(sprite: player, velocity: velocity)
            //            }
            let delta = lastTouchLocation - player.position
            let distance = delta.length()
            
            if distance < playerMovePerSecond * dt {
                player.position = lastTouchLocation
                velocity = .zero
                stopWalkAnimation()
            } else {
                moveSprite(sprite: player, velocity: velocity)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //        let touchLocation = touch.location(in: self)
        let touchLocation = touch.location(in: mazeContainer)
        
        lastTouchLocation = touchLocation
        movePlayerTowards(location: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //        let touchLocation = touch.location(in: self)
        let touchLocation = touch.location(in: mazeContainer)
        
        lastTouchLocation = touchLocation
        movePlayerTowards(location: touchLocation)
    }
}

extension GameScene {
    private func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
//        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
//        let proposedPosition = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        //        sprite.position = proposedPosition
        player.physicsBody?.velocity = CGVector(dx: velocity.x, dy: velocity.y)
        
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
        player.texture = SKTexture(imageNamed: "run1")
    }
    
    func createLevel() {
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
        
        // Iterate over the rows (i.e., the y-axis)
        for (row, columnArray) in levelMap.enumerated() {
            
            // Iterate over the columns in the current row (i.e., the x-axis)
            for (col, mapValue) in columnArray.enumerated() {
                
                var node: SKSpriteNode? = nil
                let position = CGPoint(
                    x: CGFloat(col) * WALL_SIZE + (WALL_SIZE / 2),
                    y: (CGFloat(MAP_ROWS) - 1 - CGFloat(row)) * WALL_SIZE + (WALL_SIZE / 2)
                )
                
                if mapValue == 1 {
                    // **Wall Block**
                    node = SKSpriteNode(texture: wallTexture, size: CGSize(width: WALL_SIZE, height: WALL_SIZE))
                    node?.name = "wall"
                    
                    // Add the physics body for collision (critical for walls)
                    node?.physicsBody = SKPhysicsBody(rectangleOf: node!.size)
                    node?.physicsBody?.isDynamic = false // Walls should not move
                    node?.physicsBody?.categoryBitMask = PhysicsCategory.wall
                    
                } else if mapValue == 2 {
                    player.size = CGSize(width: WALL_SIZE, height: WALL_SIZE)
                    player.position = position
                    player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width * 0.6, height: player.size.height * 0.6))
                    
                    player.physicsBody?.allowsRotation = false
                    player.physicsBody?.affectedByGravity = false
                    
                    player.physicsBody?.categoryBitMask = PhysicsCategory.player
                    player.physicsBody?.collisionBitMask = PhysicsCategory.wall
                    player.physicsBody?.contactTestBitMask = PhysicsCategory.exit
                    node = player
                } else if mapValue == 3 {
                    node = SKSpriteNode(texture: exitTexture, size: CGSize(width: WALL_SIZE, height: WALL_SIZE))
                    node?.name = "exit"
                    
                    // Add physics body for contact detection (player wins when touching this)
                    node?.physicsBody = SKPhysicsBody(rectangleOf: node!.size)
                    node?.physicsBody?.isDynamic = false // Exit marker should not move
                    node?.physicsBody?.categoryBitMask = PhysicsCategory.exit
                }
                
                if let newNode = node {
                    newNode.position = position
                    mazeContainer.addChild(newNode)
                }
            }
        }
    }
    
    func calculateOptimalWallSize() -> CGFloat {
        
        let totalCols = CGFloat(MAP_COLS)
        let totalRows = CGFloat(MAP_ROWS)
        
        let sceneWidth = size.width
        let sceneHeight = size.height
        
        let maxWallSizeByWidth = sceneWidth / totalCols
        let maxWallSizeByHeight = sceneHeight / totalRows
        let optimalSize = min(maxWallSizeByWidth, maxWallSizeByHeight) - 2.0
        return max(10.0, optimalSize)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let first = contact.bodyA.categoryBitMask
        let second = contact.bodyB.categoryBitMask
        
        if first == PhysicsCategory.player && second == PhysicsCategory.exit ||
            first == PhysicsCategory.exit && second == PhysicsCategory.player {
            print("EXIT REACHED — LEVEL COMPLETE")
        }
    }
}

struct PhysicsCategory {
    static let none: UInt32  = 0
    static let player: UInt32 = 0b1 // 1
    static let wall: UInt32   = 0b10 // 2
    static let exit: UInt32   = 0b100 // 4
}
