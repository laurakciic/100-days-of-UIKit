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
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))      // canvas 512x512 points, also stores info how we want do draw
        
        let image = renderer.image { ctx in                                                // context parameter
            // drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)                                                 // 10 point border around rectangle, centered on the edge of rect, 5 points inside, 5 points outside 
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)                                     // fill rectangle and draw border
        }
        
        imageView.image = image                                                            // put rendered image in imageView on UIView
    }
}

