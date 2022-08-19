//
//  GameScene.swift
//  P11_Pachinko
//
//  Created by Laura on 19.08.2022..
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
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
        guard let touch = touches.first else { return }                             // attempt to read the first touch that came in
        let location = touch.location(in: self)                                     // find where the touch was in the whole game scene
        
        let ball = SKSpriteNode(imageNamed: "ballBlue")                             // create ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)     // to have balls behave like balls not rectangles
        ball.physicsBody?.restitution = 0.4                                         // bounciness, 0-not bouncy to 1-super bouncy
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0  // collisionBitmask tells us which nodes should I bump into (by default all), contactTestBitMask - which collisions you want to know about - by default, none ---> bounce off everything that has physics bodies also tell us about every bounce
        ball.position = location
        ball.name = "ball"                                                          // spritenodes name
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false                                      // object will collide with other things but won't be moved, will be fixed in place
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood{
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
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }                        // if the other thing has been removed since the collision happened, return
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {                                                   // contact.bodyA.node?.name or nodeA
            collision(between: nodeA, object: contact.bodyB.node!)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: contact.bodyA.node!)
        }
    }
}
