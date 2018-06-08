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
    //保存座標
    var savePos:(x:CGFloat, y:CGFloat)!
    
    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        backgroundNode = childNode(withName: "Background") as! SKSpriteNode
        backgroundNode.isPaused = true
        bNode = childNode(withName: "BNode") as! SKSpriteNode
        bNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        bNode.physicsBody?.affectedByGravity = false
        bNode.isHidden = true
        lightNode = childNode(withName: "Light") as! SKShapeNode
        lightNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        lightNode.physicsBody?.affectedByGravity = false
        lightNode.physicsBody?.isDynamic = false
        
        
        bNode.physicsBody?.categoryBitMask = 0b0010
        lightNode.physicsBody?.categoryBitMask = 0b0001
        
        bNode.physicsBody?.collisionBitMask = 0b0001
        lightNode.physicsBody?.collisionBitMask = 0b0001
        
        for i in 0..<10 {
            aNode.append(childNode(withName: "ANode") as! SKSpriteNode)
            aNode[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            aNode[i].physicsBody?.affectedByGravity = false
            aNode[i].position = CGPoint(x:200, y:0);
            aNode[i].physicsBody?.friction = 0.0
            angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
            value = 80.0
            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
            aNode[i].physicsBody?.applyImpulse(vector!)
            //回転のアクションを実行する。
            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
            aNode[i].run(rotateAction1)
            savePos = (aNode[i].position.x, aNode[i].position.y)
            aNode[i].physicsBody?.categoryBitMask = 0b0001
            aNode[i].physicsBody?.collisionBitMask = 0b0001
            lightNode.physicsBody?.contactTestBitMask = aNode[i].physicsBody!.categoryBitMask | bNode.physicsBody!.categoryBitMask
        }
        
        //テクスチャアトラスからボタン作成
//        let button = SKSpriteNode(texture: SKTextureAtlas(named: "UIParts").textureNamed("button"))
        //イメージからそのままの場合は
        let button = SKSpriteNode(imageNamed: "antbutton.png")
        button.position = CGPoint(x:-304, y:-582)
        button.zPosition = 1
        button.name = "button"
        self.addChild(button)
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
            }
        }
    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //タッチ座標を取得する。
//        let location = touches.first!.location(in: self)
//        //前回保存座標とタッチ座標の角度を算出する。
//        let r = atan2(savePos.y - location.y, savePos.x - location.x)
//        if(fabs(location.y - savePos.y) > 10.0 || fabs(location.x - savePos.x) > 10.0) {
//            if(location.x - savePos.x > 0) {
//                //右に移動した場合は右向きにする。
//                aNode.xScale = fabs(aNode.xScale) * -1.0
//                //回転のアクションを実行する。
//                let rotateAction = SKAction.rotate( toAngle: r - CGFloat(Double.pi), duration: 0)
//                aNode.run(rotateAction)
//            } else {
//                //左に移動した場合は左向きにする。
//                aNode.xScale = fabs(aNode.xScale)
//                //回転のアクションを実行する。
//                let rotateAction = SKAction.rotate(toAngle: r , duration: 0)
//                aNode.run(rotateAction)
//            }
//            //座標を保存する.
//            savePos = (location.x, location.y)
//        }
//        //タッチ座標に移動するアクションを実行する。
//        let action = SKAction.move(to: CGPoint(x:location.x, y:location.y+20), duration:0.1)
//        aNode.run(action)
//    }
//}
//
//extension GameScene: SKPhysicsContactDelegate {
//    func didBegin(_ contact: SKPhysicsContact) {
//        print("------------衝突しました------------")
//        print("bodyA:\(contact.bodyA.node?.name)")
//        print("bodyB:\(contact.bodyB.node?.name)")
//        aNode.physicsBody?.velocity = CGVector(dx: 0, dy:0)
//        if contact.bodyA.categoryBitMask == aNode.physicsBody!.categoryBitMask {
//            lightNode.fillColor = UIColor.yellow
//            angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
//            value = 80.0
//            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
//            aNode.physicsBody?.applyImpulse(vector!)
//            //回転のアクションを実行する。
//            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
//            aNode.run(rotateAction1)
//            savePos = (aNode.position.x, aNode.position.y)
//        }else if contact.bodyA.categoryBitMask == bNode.physicsBody!.categoryBitMask {
//            lightNode.fillColor = UIColor.cyan
//            angle = self.randomFloatValue(0, high: 360) * CGFloat.pi / 180.0
//            value = 80.0
//            vector = CGVector(dx: (value * CGFloat(cos(Double(angle)))), dy: (value * CGFloat(sin(Double(angle)))))
//            aNode.physicsBody?.applyImpulse(vector!)
//            //回転のアクションを実行する。
//            let rotateAction1 = SKAction.rotate( toAngle: angle - CGFloat(Double.pi), duration: 0)
//            aNode.run(rotateAction1)
//            savePos = (aNode.position.x, aNode.position.y)
//        }
//    }
//
//    func didEnd(_ contact: SKPhysicsContact) {
//        lightNode.fillColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 216/255)
//    }
}
