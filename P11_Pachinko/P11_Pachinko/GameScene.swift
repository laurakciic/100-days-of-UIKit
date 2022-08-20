//
//  GameScene.swift
//  P11_Pachinko
//
//  Created by Laura on 19.08.2022..
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var ballCountLabel: SKLabelNode!
    var boxes = [SKSpriteNode]()
    
    var ballCount = 5 {
        didSet {
            ballCountLabel.text = "Balls left: \(ballCount)"
        }
    }
    
    var balls = ["ballBlue", "ballCyan", "ballGreen", "ballYellow", "ballGrey", "ballPurple", "ballRed"]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
    
        ballCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballCountLabel.text = "Balls left: 5"
        ballCountLabel.horizontalAlignmentMode = .right
        ballCountLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballCountLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
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
        let objects = nodes(at: location)
        
        // tells whether we are in editing mode or not
        if objects.contains(editLabel) {
            editingMode.toggle()                                                    // toggle flips boolean from true to false or false to true, same as editingMode = !editingMode
        } else {
            if editingMode {
                // create a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)          // create random size
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size) // random boxes
                box.zRotation = CGFloat.random(in: 0...3)                               // rotate it random number of radians between 0 and 3 (bit less than 180 deg)
                box.position = location                                                 // place it where was tapped
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)                  // give it a rectangle physics body
                box.physicsBody?.isDynamic = false                                      // don't allow to move (as balls bounce of it, they won't move around on the screen)
                addChild(box)                                                           // add to game scene
                
                box.name = "box"
                boxes.append(box)
                
            } else {
                
                if ballCount > 0 {
                    let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballRed")     // create ball
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)     // to have balls behave like balls not rectangles
                    ball.physicsBody?.restitution = 0.4                                         // bounciness, 0-not bouncy to 1-super bouncy
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0  // collisionBitmask tells us which nodes should I bump into (by default all), contactTestBitMask - which collisions you want to know about - by default, none ---> bounce off everything that has physics bodies also tell us about every bounce
                    ball.position = location
                    if (location.y < 600) {
                        ball.position.y = 600
                    }
                    ball.name = "ball"                                                          // spritenodes name
                    addChild(ball)
                    
                    ballCount -= 1
                }
            }
        }
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
            score += 1
            ballCount += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box" {
            let box = nodes(at: object.position)
            box[0].removeFromParent()
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
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
