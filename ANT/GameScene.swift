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
    var timeLabel = SKLabelNode(text: "○時間○分○秒")
    var antLabel = SKLabelNode(text: "○秒")
    var backgroundNode: SKSpriteNode!
    var backgroundoutNode: SKSpriteNode!
    var aNode: [SKSpriteNode!] = []
    var bNode: SKSpriteNode!
    var cNode: SKSpriteNode!
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
    var twButton: SKSpriteNode!
    var fbButton: SKSpriteNode!
    var touchButtonName:String? = ""
    let button = SKSpriteNode(imageNamed: "donutButton.png")
    let button3 = SKSpriteNode(imageNamed: "chalk.png")

    
    //保存座標
    var savePos:(x:CGFloat, y:CGFloat)!
    
    

    
    override func didMove(to view: SKView) {
        countTime = defaults.integer(forKey: "time")
        antLabel = childNode(withName: "antLabel") as! SKLabelNode
        antCount = defaults.integer(forKey: "antCount")
        antLabel.text = "潰した蟻\(antCount)匹"
        physicsWorld.contactDelegate = self
        timeLabel = childNode(withName: "timeLabel") as! SKLabelNode
        backgroundNode = childNode(withName: "Background") as! SKSpriteNode
        backgroundNode.isPaused = true
        
        backgroundNode.physicsBody = SKPhysicsBody(edgeLoopFrom: backgroundNode.frame)
        backgroundNode.physicsBody?.isDynamic = false
        backgroundNode.physicsBody?.friction = 0
        bNode = childNode(withName: "BNode") as! SKSpriteNode
        bNode.physicsBody = SKPhysicsBody(rectangleOf: bNode.frame.size)
        bNode.physicsBody?.affectedByGravity = false
        bNode.isHidden = true
        bNode.physicsBody?.isDynamic = false
        
        cNode = childNode(withName: "CNode") as! SKSpriteNode
        cNode.physicsBody = SKPhysicsBody(rectangleOf: cNode.frame.size)
        cNode.physicsBody?.affectedByGravity = false
        cNode.physicsBody?.isDynamic = false
        
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
        
        twButton = childNode(withName: "twButton") as! SKSpriteNode
        twButton.name = "twitter_button"
        
        fbButton = childNode(withName: "fbButton") as! SKSpriteNode
        fbButton.name = "facebook_button"
    }
    
    func socialButtonTapped(social:String){
        
        // share画面で表示するメッセージを格納
        var message = String()
        if social == "twitter" {
            message = "Twitter Share"
        } else {
            message = "Facebook Share"
        }
        
        // userinfoに情報(socialの種類とmessage)を格納
        let userInfo = ["social": social.data(using: String.Encoding.utf8, allowLossyConversion: true)!,"message": message.data(using: String.Encoding.utf8, allowLossyConversion: true)!]
        
        print(userInfo)
        
        // userInfoも含めて、"socialShare"という名称の通知をここで飛ばす
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "socialShare"), object: nil, userInfo: userInfo)
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
        let hours = span / hourSec
        // 分
        let minutes = (span - hourSec * hours) / minuteSec
        // 残りは秒
        let secs = (span - hourSec * hours - minutes * minuteSec)
        timeLabel.text = "プレイ時間\(hours)時間 \(minutes)分 \(secs)秒" // 今回追加
        defaults.set(time, forKey: "time")
    }
    
    
    fileprivate func randomFloatValue(_ low: CGFloat, high: CGFloat) -> CGFloat {
        return ((CGFloat(arc4random()) / CGFloat(RAND_MAX)) * (high - low) + low)
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                    antLabel.text = "潰した蟻\(antCount)匹"
                    defaults.set(antCount, forKey: "antCount")
                    break
                }
            }
            if self.atPoint(location).name == "twitter_button" {
                socialButtonTapped(social: "twitter")
//                print("a")
            } else if self.atPoint(location).name == "facebook_button" {
                socialButtonTapped(social: "facebook")
//                print("b")
            }
            if self.atPoint(location).name == "button" {
                if button.colorBlendFactor == 0{
                    button.color = UIColor.gray
                    button.colorBlendFactor = 1
                    bNode.isHidden = false
                    bNode.physicsBody?.categoryBitMask = UInt32(1)
                    for i in 0..<aNode.count {
                        let radian = atan2(-aNode[i].position.x + bNode.position.x, -aNode[i].position.y + bNode.position.y)
                        value = 80.0
                        vector = CGVector(dx: (value * CGFloat(cos(radian))), dy: (value * CGFloat(sin(radian))))
                        aNode[i].physicsBody?.applyImpulse(vector!)
                        aNode[i].physicsBody?.velocity = vector!
                        //回転のアクションを実行する。
                        let rotateAction1 = SKAction.rotate( toAngle: radian - CGFloat(Double.pi), duration: 0)
                        aNode[i].run(rotateAction1)
                        savePos = (aNode[i].position.x, aNode[i].position.y)
                        aNode[i].physicsBody?.categoryBitMask = UInt32(i+5)
                        aNode[i].physicsBody?.collisionBitMask = 0xFFFFFFFF
                        aNode[i].physicsBody?.contactTestBitMask = aNode[i].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask | lineNode.physicsBody!.categoryBitMask | cNode.physicsBody!.categoryBitMask
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
                 lineNode.isHidden = false
                } else {
                 button3.color = UIColor.gray
                 button3.colorBlendFactor = 1
                 lineNode.isHidden = true
                }
            }
        }
    }
    @objc func timerUpdate() {
         button.colorBlendFactor = 0
         bNode.isHidden = true
         bNode.physicsBody?.categoryBitMask = 0x00000000
    }
    //@objc func timerUpdate2() {
    //    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if lineNode.isHidden == false{
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
//        self.timer = Timer(timeInterval: 0, target: self, selector: #selector(GameScene.timerUpdate2), userInfo: nil, repeats: false)
//        RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lineNode.removeFromParent()
//        for i in 0..<aNode.count {
//            aNode[i].physicsBody?.contactTestBitMask = lineNode.physicsBody!.categoryBitMask
//        }
        
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
//        print(contact.bodyA)
//        print(contact.bodyB)
//        print("------------衝突しました------------")
        if contact.bodyB.categoryBitMask == lineNode.physicsBody!.categoryBitMask {
//            print("------------衝突しました------------")
            angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
            value = 80.0
            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
            contact.bodyA.node?.physicsBody?.applyImpulse(vector!)
            contact.bodyA.node?.physicsBody?.velocity = vector!
            //回転のアクションを実行する。
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            contact.bodyA.node?.run(rotateAction1)
            savePos = (contact.bodyA.node?.position.x, contact.bodyA.node?.position.y) as! (x: CGFloat, y: CGFloat)
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
                self.timer = Timer(timeInterval: 5, target: self, selector: #selector(GameScene.timerUpdate), userInfo: nil, repeats: false)
                RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
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
