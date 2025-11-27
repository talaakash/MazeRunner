//
//  GameViewController.swift
//  MazeRunner
//
//  Created by Admin on 25/11/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    private let map = [
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let mazeConfig = MazeConfig(map: map, wallTextureName: "tile_wall", floorTextureName: "tile_floor", exitTextureName: "joystick_base", playerTexturePrefix: "run1", playerFrames: 16, playerSpeed: 150, giftInitialTime: 5, giftIncrement: 5)
            let scene = GameScene(size: view.bounds.size, config: mazeConfig)
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = true
            view.showsNodeCount = true
            view.showsFPS = true
            view.presentScene(scene)
        }
    }
}
