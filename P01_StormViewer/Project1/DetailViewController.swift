//
//  DetailViewController.swift
//  Project1
//
//  Created by Laura on 08.08.2022..
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!                       // ! bc when DetailViewController is being created, image view is not loaded yet
    
    var selectedImage:       String?
    var selectedImageNumber: Int?
    var totalImageCount:     Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(selectedImageNumber!) of \(totalImageCount!)"
        
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {                    // checks & unwraps the optional into the selected image
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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
