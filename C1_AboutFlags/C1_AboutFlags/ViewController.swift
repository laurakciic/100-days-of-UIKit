//
//  ViewController.swift
//  C1_AboutFlags
//
//  Created by Laura on 10.08.2022..
//

import UIKit

class ViewController: UIViewController {

    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png") {
                flags.append(item)
            }
        }
    }


}

