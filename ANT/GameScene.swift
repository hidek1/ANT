//
//  GameScene.swift
//  ANT
//
//  Created by 吉永秀和 on 2018/06/06.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//
import Foundation
import SpriteKit

class GameScene: SKScene {
    var timeLabel = SKLabelNode(text: "○ hour ○ min ○ sec")
    var antLabel = SKLabelNode(text: "○ sec")
    var backgroundNode: SKSpriteNode!
    var backgroundoutNode: SKSpriteNode!
    var aNode: [SKSpriteNode!] = []
    var bNode: SKSpriteNode!
    var cNode: SKSpriteNode!
    var dNode: SKSpriteNode!
    var touchedNode: SKNode?
    var angle: CGFloat = 0
    var value: CGFloat = 0
    var vector: CGVector?
    var timer: Timer?
    var firstPoint: CGPoint?
    var lineNode = SKShapeNode()
    var prevTime: TimeInterval = 0
    var startTime: TimeInterval = 0
    var countTime: Int = 0
    let defaults = UserDefaults.standard
    var time: Int = 0
    var antCount: Int = 0
    var touchButtonName:String? = ""
    let button = SKSpriteNode(imageNamed: "donutButton.png")
    let button3 = SKSpriteNode(imageNamed: "chalk.png")
    var sharebutton : SKSpriteNode!
    
    // 時間
    var hours: Int = 0
    // 分
    var minutes: Int = 0
    // 残りは秒
    var secs: Int = 0

    
    //保存座標
    var savePos:(x:CGFloat, y:CGFloat)!
    
    

    
    override func didMove(to view: SKView) {
        countTime = defaults.integer(forKey: "time")
        antLabel = childNode(withName: "antLabel") as! SKLabelNode
        antCount = defaults.integer(forKey: "antCount")
        antLabel.text = String(format: NSLocalizedString("Smashed ants", comment: ""), antCount)
        physicsWorld.contactDelegate = self
        timeLabel = childNode(withName: "timeLabel") as! SKLabelNode
        backgroundNode = childNode(withName: "Background") as! SKSpriteNode
        backgroundNode.isPaused = true
        
        backgroundNode.physicsBody = SKPhysicsBody(edgeLoopFrom: backgroundNode.frame)
        backgroundNode.physicsBody?.isDynamic = false
        backgroundNode.physicsBody?.friction = 0
        bNode = SKSpriteNode(imageNamed: "donut.png")
        bNode.size = CGSize.init(width: 150, height: 150)
        bNode.position = CGPoint(x: 0, y: 0)
        bNode.physicsBody = SKPhysicsBody(rectangleOf: bNode.frame.size)
        bNode.physicsBody?.affectedByGravity = false
        bNode.isHidden = true
        bNode.physicsBody?.isDynamic = false
        addChild(bNode)
        
        cNode = childNode(withName: "CNode") as! SKSpriteNode
        cNode.physicsBody = SKPhysicsBody(rectangleOf: cNode.frame.size)
        cNode.physicsBody?.affectedByGravity = false
        cNode.physicsBody?.isDynamic = false
        
        dNode = SKSpriteNode(imageNamed: "donut.png")
        dNode.size = CGSize.init(width: 150, height: 150)
        dNode.isHidden = true
        dNode.alpha = 0.5
        addChild(dNode)
        
        lineNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: lineNode.lineWidth, height: 5000))
        lineNode.isHidden = true
        lineNode.physicsBody?.isDynamic = false
        lineNode.physicsBody?.categoryBitMask = UInt32(2)
        lineNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
        
        
        //print(lineNode.physicsBody)
        
        cNode.physicsBody?.categoryBitMask = UInt32(4)
        bNode.physicsBody?.categoryBitMask = 0x00000000
        backgroundNode.physicsBody?.categoryBitMask = UInt32(3)
        
        cNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
        bNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
        backgroundNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
        
        
        let Texture1 = SKTexture(imageNamed: "ant.png")
        Texture1.filteringMode = .nearest
        let Texture2 = SKTexture(imageNamed: "ant2.png")
        Texture2.filteringMode = .nearest
        let Texture3 = SKTexture(imageNamed: "ant4.png")
        Texture3.filteringMode = .nearest
        
        let anim = SKAction.animate(with: [Texture1, Texture2, Texture1, Texture3], timePerFrame: 0.1)
        let flap = SKAction.repeatForever(anim)
        for i in 0..<10 {
            aNode.append(SKSpriteNode(imageNamed: "ant.png"))
            aNode[i].name = "normal"
            aNode[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 100))
            aNode[i].physicsBody?.affectedByGravity = false
            aNode[i].position = CGPoint(x:100, y:40*i);
            aNode[i].xScale = 0.08
            aNode[i].yScale = 0.08
            aNode[i].physicsBody?.friction = 0.0
             aNode[i].physicsBody?.linearDamping = 0
            angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
            value = 80.0
            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
            aNode[i].physicsBody?.applyImpulse(vector!)
            aNode[i].physicsBody?.velocity = vector!
            aNode[i].run(flap)
            //回転のアクションを実行する。
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            aNode[i].run(rotateAction1)
            savePos = (aNode[i].position.x, aNode[i].position.y)
            aNode[i].physicsBody?.categoryBitMask = UInt32(i+4)
            aNode[i].physicsBody?.collisionBitMask = 0xFFFFFFFF
            aNode[i].physicsBody?.contactTestBitMask = aNode[i].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask | lineNode.physicsBody!.categoryBitMask | cNode.physicsBody!.categoryBitMask
            self.addChild(aNode[i])
//            print(aNode[i].position)
        }
        
        //テクスチャアトラスからボタン作成
//        let button = SKSpriteNode(texture: SKTextureAtlas(named: "UIParts").textureNamed("button"))
        //イメージからそのままの場合は
        button.position = CGPoint(x:-261.5, y:-555)
        button.zPosition = 1
        button.name = "button"
        self.addChild(button)
        
        let button2 = SKSpriteNode(imageNamed: "antbutton.png")
        button2.position = CGPoint(x:0, y:-555)
        button2.zPosition = 1
        button2.name = "button2"
        self.addChild(button2)
        
        button3.position = CGPoint(x:261.5, y:-555)
        button3.zPosition = 1
        button3.name = "button3"
        button3.color = UIColor.gray
        button3.colorBlendFactor = 1
        self.addChild(button3)
        
        sharebutton = childNode(withName: "share") as! SKSpriteNode
        sharebutton.zPosition = 1
        sharebutton.name = "sharebutton"

        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if prevTime == 0 {
            prevTime = currentTime
            startTime = currentTime
        }
//        agentSystem.update(deltaTime: currentTime - prevTime)
        time = countTime + Int(currentTime - startTime) // 今回追加

        
        let span = time
        
        let hourSec = 60 * 60     // 1時間の秒数
        let minuteSec = 60        // 1分の秒数
        
        // 時間
        hours = span / hourSec
        // 分
        minutes = (span - hourSec * hours) / minuteSec
        // 残りは秒
        secs = (span - hourSec * hours - minutes * minuteSec)
        timeLabel.text = String(format: NSLocalizedString("Playing time", comment: ""), hours,minutes,secs)
//            NSLocalizedString("Playing time", comment: "",hours,minutes,secs) // 今回追加
//        defaults.set(time, forKey: "time")
        
        
        for i in 0..<aNode.count {
            if aNode[i].name == "fast" {
                value = 280.0
                vector = CGVector(dx: (-value * CGFloat(cos(aNode[i].zRotation))), dy: (-value * CGFloat(sin(aNode[i].zRotation))))
                aNode[i].physicsBody?.velocity = vector!
            } else {
                value = 80.0
                vector = CGVector(dx: (-value * CGFloat(cos(aNode[i].zRotation))), dy: (-value * CGFloat(sin(aNode[i].zRotation))))
                aNode[i].physicsBody?.velocity = vector!
                
            }
            if backgroundNode.contains(aNode[i].position) == false  {
                aNode[i].removeFromParent()
                //                    print(aNode.count)
                  aNode.remove(at: i)
//                  print("消えた")
                break
            }
        }
    }
    func defaultSet() {
        defaults.set(time, forKey: "time")
    }
    func defaultGet() {
        countTime = defaults.integer(forKey: "time")
        startTime = CACurrentMediaTime()
    }
    
    
    
    fileprivate func randomFloatValue(_ low: CGFloat, high: CGFloat) -> CGFloat {
        return ((CGFloat(arc4random()) / CGFloat(RAND_MAX)) * (high - low) + low)
    }
    
    @objc func timerUpdate() {
        button.colorBlendFactor = 1
        bNode.texture = SKTexture(imageNamed: "donut2.png")
        bNode.size = CGSize.init(width: 100, height: 100)
        self.timer = Timer(timeInterval: 0.5, target: self, selector: #selector(GameScene.timerUpdate2), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    @objc func timerUpdate2() {
        button.colorBlendFactor = 1
        bNode.isHidden = true
        bNode.physicsBody?.categoryBitMask = 0x00000000
        bNode.texture = SKTexture(imageNamed: "donut.png")
        bNode.size = CGSize.init(width: 150, height: 150)
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(GameScene.timerUpdate3), userInfo: nil, repeats: false)
        RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    @objc func timerUpdate3() {
        if button3.colorBlendFactor == 1 {
            button.colorBlendFactor = 0
        }
        self.timer?.invalidate()
        
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0..<aNode.count {
            aNode[i].name = "normal"
        }
        lineNode.removeFromParent()
        lineNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: lineNode.lineWidth, height: 5000))
        let touch = touches.first!
        firstPoint = touch.location(in: self)
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            for i in 0..<aNode.count {
                if self.atPoint(location) == aNode[i] {
                     aNode[i].removeFromParent()
//                    print(aNode.count)
                    aNode.remove(at: i)
//                    print(aNode.count)
                    antCount += 1
                    antLabel.text = String(format: NSLocalizedString("Smashed ants", comment: ""), antCount)
                    defaults.set(antCount, forKey: "antCount")
                    break
                }
            }
            if self.atPoint(location).name == "button" {
                if button.colorBlendFactor == 0{
                      bNode.name = "possible"
                } else {
                    if bNode.isHidden == true {
                       button.colorBlendFactor = 0
                       button3.colorBlendFactor = 1
                    }
                }
            }
            if self.atPoint(location).name == "button2" {
                if aNode.count < 50 {
                    let Texture1 = SKTexture(imageNamed: "ant.png")
                    Texture1.filteringMode = .nearest
                    let Texture2 = SKTexture(imageNamed: "ant2.png")
                    Texture2.filteringMode = .nearest
                    let Texture3 = SKTexture(imageNamed: "ant4.png")
                    Texture3.filteringMode = .nearest
                    
                    let anim = SKAction.animate(with: [Texture1, Texture2, Texture1, Texture3], timePerFrame: 0.1)
                    let flap = SKAction.repeatForever(anim)
                    aNode.append(SKSpriteNode(imageNamed: "ant.png"))
                    aNode[aNode.count-1].name = "normal"
                    aNode[aNode.count-1].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 100))
                    aNode[aNode.count-1].physicsBody?.affectedByGravity = false
                    aNode[aNode.count-1].position = CGPoint(x:100, y:70);
                    aNode[aNode.count-1].xScale = 0.08
                    aNode[aNode.count-1].yScale = 0.08
                    aNode[aNode.count-1].physicsBody?.friction = 0.0
                    aNode[aNode.count-1].physicsBody?.linearDamping = 0
                    angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
                    value = 80.0
                    vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
                    aNode[aNode.count-1].physicsBody?.applyImpulse(vector!)
                    aNode[aNode.count-1].physicsBody?.velocity = vector!
                    aNode[aNode.count-1].run(flap)
                    //回転のアクションを実行する。
                    let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
                    aNode[aNode.count-1].run(rotateAction1)
                    savePos = (aNode[aNode.count-1].position.x, aNode[aNode.count-1].position.y)
                    aNode[aNode.count-1].physicsBody?.categoryBitMask = UInt32(aNode.count+3)
                    aNode[aNode.count-1].physicsBody?.collisionBitMask = 0xFFFFFFFF
                    aNode[aNode.count-1].physicsBody?.contactTestBitMask = aNode[aNode.count-1].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask | lineNode.physicsBody!.categoryBitMask | cNode.physicsBody!.categoryBitMask
                    self.addChild(aNode[aNode.count-1])
                }
            }
            
            if self.atPoint(location).name == "button3" {
                if button3.colorBlendFactor == 1{
                 button3.colorBlendFactor = 0
                 button.color = UIColor.gray
                 button.colorBlendFactor = 1
                 lineNode.isHidden = false
                } else {
                 button3.color = UIColor.gray
                 button3.colorBlendFactor = 1
                 button.colorBlendFactor = 0
                 lineNode.isHidden = true
                }
            }
            if self.atPoint(location).name == "sharebutton" {
                let text = String(format: NSLocalizedString("share", comment: ""), hours,minutes,secs,antCount)
                let sampleUrl = NSURL(string: "http://appstore.com/")!
//                let image = UIImage(named: "ant.png")!
                let items = [text, sampleUrl] as [Any]
                
                // UIActivityViewControllerをインスタンス化
                let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                
                
                var currentViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController!
                currentViewController?.present(activityVc, animated: true, completion: nil)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if button3.colorBlendFactor == 0 {
            let touch = touches.first!
            let position = touch.location(in: self)
            let path = CGMutablePath()
            path.move(to: firstPoint!)
            path.addLine(to: position)
            lineNode.path = path
            lineNode.lineWidth = 10.0
            lineNode.strokeColor = UIColor.white
            //firstPoint = position
            lineNode.fillColor = UIColor.red
            lineNode.physicsBody = SKPhysicsBody(edgeChainFrom: lineNode.path!)
            lineNode.physicsBody?.isDynamic = false
            lineNode.physicsBody?.categoryBitMask = UInt32(2)
            lineNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
            lineNode.removeFromParent()
            self.addChild(lineNode)
        }
        
        if bNode.name == "possible" {
            let touch = touches.first!
//            let position = touch.location(in: self)
            dNode.position = touch.location(in: self)
            dNode.isHidden = false
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dNode.isHidden = true
        if bNode.name == "possible" {
             let touch = touches.first!
             let position = touch.location(in: self)
//            print(backgroundNode)
            if self.atPoint(position) == backgroundNode{
                bNode.position = touch.location(in: self)
                button.color = UIColor.gray
                button.colorBlendFactor = 1
                bNode.isHidden = false
                bNode.physicsBody?.categoryBitMask = UInt32(1)
                for i in 0..<aNode.count {
                    let radian = atan2(bNode.position.x - aNode[i].position.x, bNode.position.y - aNode[i].position.y)
                    value = 80.0
                    vector = CGVector(dx: (-value * CGFloat(cos(radian))), dy: (-value * CGFloat(sin(radian))))
                    //                            aNode[i].physicsBody?.applyImpulse(vector!)
                    //                            aNode[i].physicsBody?.velocity = vector!
                    //回転のアクションを実行する。
                    let rotateAction1 = SKAction.rotate( byAngle: radian, duration: 0)
                    aNode[i].run(rotateAction1)
                    let rotateAction2 = SKAction.move(to: touch.location(in: self), duration: 1.5)
                    aNode[i].run(rotateAction2)
                    
                    savePos = (aNode[i].position.x, aNode[i].position.y)
                    aNode[i].physicsBody?.categoryBitMask = UInt32(i+5)
                    aNode[i].physicsBody?.collisionBitMask = 0xFFFFFFFF
                    aNode[i].physicsBody?.contactTestBitMask = aNode[i].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask | lineNode.physicsBody!.categoryBitMask | cNode.physicsBody!.categoryBitMask
                }
            }
        }
        bNode.name = "impossible"
        
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
//        print(contact.bodyA)
//        print(contact.bodyB)
//        print("------------衝突しました------------")
        if contact.bodyA.categoryBitMask == lineNode.physicsBody!.categoryBitMask {
            contact.bodyB.node?.name = "fast"
//            print("------------衝突しました------------")
            angle = (self.randomFloatValue(0, high: 180) * CGFloat.pi) / 180.0
            value = 80.0
            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
            
            //            print(angle)
            contact.bodyB.node?.physicsBody?.applyImpulse(vector!)
            contact.bodyB.node?.physicsBody?.velocity = vector!
            //回転のアクションを実行する。
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            contact.bodyB.node?.run(rotateAction1)
            savePos = (contact.bodyB.node?.position.x, contact.bodyB.node?.position.y) as! (x: CGFloat, y: CGFloat)
        } else {
            angle = (self.randomFloatValue(0, high: 180) * CGFloat.pi) / 180.0
            value = 80.0
            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))

//            print(angle)
            contact.bodyB.node?.physicsBody?.applyImpulse(vector!)
            contact.bodyB.node?.physicsBody?.velocity = vector!
            //回転のアクションを実行する。
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            contact.bodyB.node?.run(rotateAction1)
            savePos = (contact.bodyB.node?.position.x, contact.bodyB.node?.position.y) as! (x: CGFloat, y: CGFloat)
            if contact.bodyA.categoryBitMask == bNode.physicsBody!.categoryBitMask {
                if bNode.name != "eaten" {
                    bNode.name = "eaten" as String
                    self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(GameScene.timerUpdate), userInfo: nil, repeats: false)
                    RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
                }
            }
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyB.categoryBitMask == lineNode.physicsBody!.categoryBitMask {
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            contact.bodyA.node?.run(rotateAction1)
        } else {
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            contact.bodyB.node?.run(rotateAction1)
        }
    }
}
