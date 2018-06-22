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
        NotificationCenter.default.addObserver(self, selector: #selector(showSocialShare), name: NSNotification.Name(rawValue: "socialShare"), object: nil)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
//                print(scene.frame,#function)

            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @objc func showSocialShare(notification: NSNotification) {
        // (1) オブザーバーから渡ってきたuserInfoから必要なデータを取得する
        let userInfo:Dictionary<String,NSData!> = notification.userInfo as! Dictionary<String,NSData!>
        let message = NSString(data: userInfo["message"]! as Data, encoding: UInt())
        let social = NSString(data: userInfo["social"]! as Data, encoding: UInt())
        // (2) userInfoの情報をもとにTwitter/Facebookボタンどちらが押されたのか特定する
        var type = String()
        if social == "twitter" {
            type = SLServiceTypeTwitter
        } else if social == "facebook" {
            type = SLServiceTypeFacebook
        }
        
        // (3) shareViewControllerを作成、表示する
        var shareView = SLComposeViewController(forServiceType: type)
        shareView?.setInitialText(message as! String)
        
        shareView?.completionHandler = {
            (result:SLComposeViewControllerResult) -> () in
            switch (result) {
            case SLComposeViewControllerResult.done:
                print("SLComposeViewControllerResult.Done")
            case SLComposeViewControllerResult.cancelled:
                print("SLComposeViewControllerResult.Cancelled")
                
            }
        }
        self.present(shareView!, animated: true, completion: nil)
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
