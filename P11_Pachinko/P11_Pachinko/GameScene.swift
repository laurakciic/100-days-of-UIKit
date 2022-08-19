//
//  GameScene.swift
//  P11_Pachinko
//
//  Created by Laura on 19.08.2022..
//

import SpriteKit

class GameScene: SKScene {
    
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
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
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false                                      // object will collide with other things but won't be moved, will be fixed in place
        addChild(bouncer)
    }
}
