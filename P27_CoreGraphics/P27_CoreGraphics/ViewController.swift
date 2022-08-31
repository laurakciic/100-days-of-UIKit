//
//  ViewController.swift
//  P27_CoreGraphics
//
//  Created by Laura on 31.08.2022..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectange()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectange()
            
        default:
            break
        }
    }
    
    func drawRectange() {
        
    }
}

