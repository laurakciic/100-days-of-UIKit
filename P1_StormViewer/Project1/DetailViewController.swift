//
//  DetailViewController.swift
//  Project1
//
//  Created by Laura on 08.08.2022..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!       // ! bc when DetailViewController is being created, image view is not loaded yet
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageToLoad = selectedImage {    // checks & unwraps the optional into the selected image
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
