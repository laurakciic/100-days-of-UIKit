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
        
        assert(slowMethod() == true, "Slow method returned false."
    }

}

