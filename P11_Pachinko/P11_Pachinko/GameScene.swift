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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }                             // attempt to read the first touch that came in
        let locationn = touch.location(in: self)                                    // find where the touch was in the whole game scene
        
        let box = SKSpriteNode(color: .blue, size: CGSize(width: 64, height: 64))   // create new box 64x64
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // give box a physics body matching it's size
        box.position = locationn                                                    // position it at touch location
        addChild(box)                                                               // add box to the screen
    }
    
}
