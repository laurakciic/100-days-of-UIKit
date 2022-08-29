//
//  ViewController.swift
//  P18_Debugging
//
//  Created by Laura on 29.08.2022..
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(1, 2, 3, separator: "-")
        print("some msg", terminator: "")   // if you don't want \n, placed after final item
    }


}

