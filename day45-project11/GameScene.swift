//
//  GameScene.swift
//  day45-project11
//




//  Created by 李沐軒 on 2019/3/29.
//  Copyright © 2019 李沐軒. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var balls = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editMode: Bool = false {
        didSet {
            if editMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var lifeLabel: SKLabelNode!
    var life = 5 {
        didSet {
            if life > 1 {
                lifeLabel.text = "balls count: \(life)"
            } else {
                lifeLabel.text = "ball count: \(life)"
            }
            
        }
    }
    
    var box: SKSpriteNode!

    override func didMove(to view: SKView) {
        
        let bk = SKSpriteNode(imageNamed: "background")
        bk.position = CGPoint(x: 512, y: 384)
        bk.blendMode = .replace
        bk.zPosition = -1
        addChild(bk)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        lifeLabel = SKLabelNode(fontNamed: "Chalkduster")
        lifeLabel.text = "balls count: 5"
        lifeLabel.position = CGPoint(x: 450, y: 700)
        addChild(lifeLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editMode.toggle()
        } else {
            if editMode {
                
                makeBox(at: location)
                
            } else {
                
                if life != 0 {
                    let ball = SKSpriteNode(imageNamed: balls.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width/2)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = location
                    ball.position.y = 650
                    ball.name = "ball"
                    addChild(ball)
                    
                }
            }
        }
      
//        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))   正方形的PhysicsBody
//        box.position = location
//        addChild(box)
        
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.frame.width/2)
        bouncer.physicsBody?.isDynamic = false
        bouncer.position = position
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func makeBox(at position: CGPoint) {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in:0...1), blue: CGFloat.random(in:0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = position
        box.name = "box"
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
    }
   
    func collisionBetween(between ball: SKNode, object: SKNode) {
        
            if object.name == "good" {
                destroy(ball: ball, sparkParticle: "MyParticle-goodSpark")
                life += 1
                score += 1
            } else if object.name == "bad" {
                destroy(ball: ball, sparkParticle: "MyParticle-badSpark")
                life -= 1
                score -= 1
            }
//            else if object.name == "box" {
//                destroyBox(box: box)
//                score += 5
//        }
 
    }
    
    
    func destroy(ball: SKNode, sparkParticle: String) {
        
        if let spartParticles = SKEmitterNode(fileNamed: sparkParticle) {
            spartParticles.position = ball.position
            addChild(spartParticles)
        }
        
        ball.removeFromParent()
    }
    
    func destroyBox(box: SKNode) {
        box.removeFromParent()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            if nodeB.name == "box" {
                score += 5
                nodeB.removeFromParent()
            }
            collisionBetween(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            if nodeA.name == "box" {
                score += 5
                nodeA.removeFromParent()
            }
            collisionBetween(between: nodeB, object: nodeA)
        }
    }
    
    
    
}









 
