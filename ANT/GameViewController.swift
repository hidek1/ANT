//
//  GameViewController.swift
//  ANT
//
//  Created by 吉永秀和 on 2018/06/06.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Social

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
////                print(scene.frame,#function)
//
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
        
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                if (UIDevice.current.model.range(of: "iPad") != nil) {
                    scene.scaleMode = .fill
                } else if UIScreen.main.nativeBounds.height == 2436.0 {
                    scene.scaleMode = .aspectFit
                } else {
                    scene.scaleMode = .aspectFill
                }
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
//        print(self.view.frame,#function)
//        print()
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
