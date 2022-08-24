//
//  ViewController.swift
//  P15_Animation
//
//  Created by Laura on 24.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 690, y: 380)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true                                                  // hide the button as soon as it's tapped
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            switch self.currentAnimation {                                      // read the current animation value
            case 0:
                break
            default:
                break
            }
        }) { finished in
            // here comes the code to unhide tap button
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

