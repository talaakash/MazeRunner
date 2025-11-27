//
//  GiftNode.swift
//  MazeRunner
//
//  Created by Admin on 27/11/25.
//

import SpriteKit

class GiftNode: SKNode {
    let sprite: SKSpriteNode
    let timerLabel: SKLabelNode
    var remainingTime: Int = 5 {
        didSet {
            timerLabel.text = "\(remainingTime)"
        }
    }
    
    override init() {
        sprite = SKSpriteNode(imageNamed: "gift")
        timerLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        
        super.init()
        
        sprite.size = CGSize(width: 40, height: 40)
        addChild(sprite)
        
        timerLabel.text = "\(remainingTime)"
        timerLabel.fontSize = 20
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: 0, y: -35)
        timerLabel.zPosition = 10
        addChild(timerLabel)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.gift
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tick() {
        remainingTime -= 1
        timerLabel.text = "\(remainingTime)"
    }
}
