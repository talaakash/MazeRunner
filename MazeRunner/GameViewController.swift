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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = true
            view.showsNodeCount = true
            view.showsFPS = true
            view.presentScene(scene)
        }
    }
}
