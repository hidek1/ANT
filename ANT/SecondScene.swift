//
//  SecondScene.swift
//  ANT
//
//  Created by 吉永秀和 on 2018/07/12.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import Foundation
import SpriteKit

class SecondScene: SKScene {
    let defaults = UserDefaults.standard
    var goldNode: SKSpriteNode!
    var silverNode: SKSpriteNode!
    var bronzeNode: SKSpriteNode!
    var redNode: SKSpriteNode!
    var blueNode: SKSpriteNode!
    var goldLabel = SKLabelNode(text: "")
    var silverLabel = SKLabelNode(text: "")
    var bronzeLabel = SKLabelNode(text: "")
    var redLabel = SKLabelNode(text: "")
    var blueLabel = SKLabelNode(text: "")
    var goldLabel2 = SKLabelNode(text: "")
    var silverLabel2 = SKLabelNode(text: "")
    var bronzeLabel2 = SKLabelNode(text: "")
    var redLabel2 = SKLabelNode(text: "")
    var blueLabel2 = SKLabelNode(text: "")
    // first ボタン
    var first = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        let antCount = defaults.integer(forKey: "antCount")
        // first ボタンの初期化
        first = self.childNode(withName: "first") as! SKSpriteNode
        if antCount >= 100000 {
          goldNode = SKSpriteNode(imageNamed: "王冠金.png")
        } else {
          goldNode = SKSpriteNode(imageNamed: "1328.png")
        }
        goldNode.size = CGSize.init(width: 150, height: 150)
        goldNode.position = CGPoint(x: 0, y: 430)
        addChild(goldNode)
        if antCount >= 50000 {
            silverNode = SKSpriteNode(imageNamed: "王冠銀.png")
        } else {
            silverNode = SKSpriteNode(imageNamed: "1328.png")
        }
        silverNode.size = CGSize.init(width: 150, height: 150)
        silverNode.position = CGPoint(x: 230, y: 110)
        addChild(silverNode)
        if antCount >= 10000 {
          bronzeNode = SKSpriteNode(imageNamed: "王冠銅.png")
        } else {
          bronzeNode = SKSpriteNode(imageNamed: "1328.png")
        }
        bronzeNode.size = CGSize.init(width: 150, height: 150)
        bronzeNode.position = CGPoint(x: -230, y: 110)
        addChild(bronzeNode)
        if defaults.integer(forKey: "donutCount") >= 1000 {
          redNode = SKSpriteNode(imageNamed: "王冠赤.png")
        } else {
          redNode = SKSpriteNode(imageNamed: "1328.png")
        }
        redNode.size = CGSize.init(width: 150, height: 150)
        redNode.position = CGPoint(x: -160, y: -315)
        addChild(redNode)
        if defaults.integer(forKey: "chalkCount") >= 30000 {
          blueNode = SKSpriteNode(imageNamed: "王冠青.png")
        } else {
          blueNode = SKSpriteNode(imageNamed: "1328.png")
        }
        blueNode.size = CGSize.init(width: 150, height: 150)
        blueNode.position = CGPoint(x: 160, y: -315)
        addChild(blueNode)
        goldLabel = childNode(withName: "goldLabel") as! SKLabelNode
        silverLabel = childNode(withName: "silverLabel") as! SKLabelNode
        bronzeLabel = childNode(withName: "bronzeLabel") as! SKLabelNode
        redLabel = childNode(withName: "redLabel") as! SKLabelNode
        blueLabel = childNode(withName: "blueLabel") as! SKLabelNode
        goldLabel2 = childNode(withName: "goldLabel2") as! SKLabelNode
        silverLabel2 = childNode(withName: "silverLabel2") as! SKLabelNode
        bronzeLabel2 = childNode(withName: "bronzeLabel2") as! SKLabelNode
        redLabel2 = childNode(withName: "redLabel2") as! SKLabelNode
        blueLabel2 = childNode(withName: "blueLabel2") as! SKLabelNode
        goldLabel.text = "ant smasher A"
        silverLabel.text = "ant smasher B"
        bronzeLabel.text = "ant smasher C"
        redLabel.text = "feeder"
        blueLabel.text = "liner"
        goldLabel2.text = NSLocalizedString("smash 100,000 ants", comment: "")
        silverLabel2.text = NSLocalizedString("smash 50,000 ants", comment: "")
        bronzeLabel2.text = NSLocalizedString("smash 10,000 ants", comment: "")
        redLabel2.text = NSLocalizedString("donut", comment: "")
        blueLabel2.text = NSLocalizedString("chalk", comment: "")
        blueLabel2.horizontalAlignmentMode = .center
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let node = atPoint(pos) as? SKSpriteNode {
            if(node == first){
                if let view = self.view {
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
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
