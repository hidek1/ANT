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
import GoogleMobileAds

var scene:GameScene = GameScene()

class GameViewController: UIViewController, GADBannerViewDelegate {
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1673671818946203/3161424544"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        if let view = self.view as! SKView? {
            scene = GameScene(fileNamed: "GameScene")!
//            if scene = GameScene(fileNamed: "GameScene") {
                if (UIDevice.current.model.range(of: "iPad") != nil) {
                    scene.scaleMode = .fill
                } else if UIScreen.main.nativeBounds.height == 2436.0 {
                    scene.scaleMode = .aspectFit
                } else {
                    scene.scaleMode = .aspectFill
                }
                view.presentScene(scene)
//            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
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
