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
    
    var backgroundNode: SKSpriteNode!
    var backgroundoutNode: SKSpriteNode!
    var aNode: [SKSpriteNode!] = []
    var bNode: SKSpriteNode!
    var lightNode: SKShapeNode!
    var touchedNode: SKNode?
    var angle: CGFloat = 0
    var value: CGFloat = 0
    var vector: CGVector?
    var timer: Timer?
    //保存座標
    var savePos:(x:CGFloat, y:CGFloat)!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundNode = childNode(withName: "Background") as! SKSpriteNode
        backgroundNode.isPaused = true
        backgroundNode.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        backgroundNode.physicsBody?.isDynamic = false
        backgroundNode.physicsBody?.friction = 0
        bNode = childNode(withName: "BNode") as! SKSpriteNode
        bNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        bNode.physicsBody?.affectedByGravity = false
        bNode.isHidden = true
        bNode.physicsBody?.velocity = CGVector(dx: -30, dy:0)
        bNode.physicsBody?.isDynamic = false
        lightNode = childNode(withName: "Light") as! SKShapeNode
        lightNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
        lightNode.physicsBody?.affectedByGravity = false
        lightNode.physicsBody?.isDynamic = false
        lightNode.physicsBody?.friction = 0
        
        
        bNode.physicsBody?.categoryBitMask = 0x00000000
        lightNode.physicsBody?.categoryBitMask = UInt32(2)
        backgroundNode.physicsBody?.categoryBitMask = UInt32(3)
        
        bNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
        lightNode.physicsBody?.collisionBitMask = 0xFFFFFFFF
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
            aNode[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 100))
            aNode[i].physicsBody?.affectedByGravity = false
            aNode[i].position = CGPoint(x:100, y:70*i);
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
            aNode[i].physicsBody?.contactTestBitMask = aNode[i].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | lightNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask
            self.addChild(aNode[i])
        }
//        print(aNode)

        
        //テクスチャアトラスからボタン作成
//        let button = SKSpriteNode(texture: SKTextureAtlas(named: "UIParts").textureNamed("button"))
        //イメージからそのままの場合は
        let button = SKSpriteNode(imageNamed: "donutButton.png")
        button.position = CGPoint(x:-261.5, y:-555)
        button.zPosition = 1
        button.name = "button"
        self.addChild(button)
        
        let button2 = SKSpriteNode(imageNamed: "antbutton.png")
        button2.position = CGPoint(x:0, y:-555)
        button2.zPosition = 1
        button2.name = "button2"
        self.addChild(button2)
    }
    
    fileprivate func randomFloatValue(_ low: CGFloat, high: CGFloat) -> CGFloat {
        return ((CGFloat(arc4random()) / CGFloat(RAND_MAX)) * (high - low) + low)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let pos = touches.first?.location(in: self) {
            touchedNode = atPoint(pos)
        }
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "button" {
                bNode.isHidden = false
                bNode.physicsBody?.categoryBitMask = UInt32(1)
                for i in 0..<aNode.count {
                    let radian = atan2(aNode[i].position.x - bNode.position.x, aNode[i].position.y - bNode.position.y)
                    value = 80.0
                    vector = CGVector(dx: (value * CGFloat(cos(Double(radian)))), dy: (value * CGFloat(sin(Double(radian)))))
                    aNode[i].physicsBody?.applyImpulse(vector!)
                    aNode[i].physicsBody?.velocity = vector!
                    //回転のアクションを実行する。
                    let rotateAction1 = SKAction.rotate( toAngle: radian - CGFloat(Double.pi), duration: 0)
                    aNode[i].run(rotateAction1)
                    savePos = (aNode[i].position.x, aNode[i].position.y)
                    aNode[i].physicsBody?.categoryBitMask = UInt32(i+4)
                    aNode[i].physicsBody?.collisionBitMask = 0xFFFFFFFF
                    aNode[i].physicsBody?.contactTestBitMask = aNode[i].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | lightNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask
                }
            }
            if self.atPoint(location).name == "button2" {
                if aNode.count < 31 {
                    let Texture1 = SKTexture(imageNamed: "ant.png")
                    Texture1.filteringMode = .nearest
                    let Texture2 = SKTexture(imageNamed: "ant2.png")
                    Texture2.filteringMode = .nearest
                    let Texture3 = SKTexture(imageNamed: "ant4.png")
                    Texture3.filteringMode = .nearest
                    
                    let anim = SKAction.animate(with: [Texture1, Texture2, Texture1, Texture3], timePerFrame: 0.1)
                    let flap = SKAction.repeatForever(anim)
                    aNode.append(SKSpriteNode(imageNamed: "ant.png"))
                    aNode[aNode.count-1].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 100))
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
                    aNode[aNode.count-1].physicsBody?.contactTestBitMask = aNode[aNode.count-1].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask | lightNode.physicsBody!.categoryBitMask | backgroundNode.physicsBody!.categoryBitMask
                    self.addChild(aNode[aNode.count-1])
                }
            }
        }
    }
    @objc func timerUpdate() {
         bNode.isHidden = true
         bNode.physicsBody?.categoryBitMask = 0x00000000
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
//        print(contact.bodyA)
//        print(contact.bodyB)
//        print("------------衝突しました------------")
//        lightNode.fillColor = UIColor.yellow
        angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
        value = 80.0
        vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
        contact.bodyB.node?.physicsBody?.applyImpulse(vector!)
        contact.bodyB.node?.physicsBody?.velocity = vector!
        //回転のアクションを実行する。
        let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
        contact.bodyB.node?.run(rotateAction1)
        savePos = (contact.bodyB.node?.position.x, contact.bodyB.node?.position.y) as! (x: CGFloat, y: CGFloat)
        if contact.bodyA.categoryBitMask == bNode.physicsBody!.categoryBitMask {
            lightNode.fillColor = UIColor.yellow
            self.timer = Timer(timeInterval: 5, target: self, selector: #selector(GameScene.timerUpdate), userInfo: nil, repeats: false)
            RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        lightNode.fillColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 216/255)
        let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
        contact.bodyB.node?.run(rotateAction1)
    }
}
