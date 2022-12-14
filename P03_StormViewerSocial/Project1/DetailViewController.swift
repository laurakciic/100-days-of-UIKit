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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))       // on tap call shareTapped, shareTapped will exist in current view controller (self), #selector says compiler that a method called shareTapped will exist and should be triggered when btn is tapped

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
    
    
    @objc func shareTapped() {
        let image = renderImage()
                
        let vc = UIActivityViewController(activityItems: [image, selectedImage?.replacingOccurrences(of: ".jpg", with: "") as Any], applicationActivities: [])
        present(vc, animated: true)
        
//        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
//            print("No image found")
//            return
//        }
//
//        // UIActivityViewController says what to share
//        let vc = UIActivityViewController(activityItems: [image, selectedImage ?? "error fetching name"], applicationActivities: [])    // creates activity view controller saying here's the thing I want to share - image, we can also provide application acitivites to show alongside system options
//        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem     // on ipad UI activity view controller must be shown from somewhere on the screen and that's reffered to as it's popoverPresentationController which made this thing appear on the screen, we're saying this thing was shown from a bar button item and telling it it's out right bar button item or iPad has to be shown attached to the bar button item so you can see where it came from and tap away to dismiss it
//        present(vc, animated: true) // to show finished UI acitivity view controller ready to go on the screen
    }
    
    func renderImage() -> UIImage {
        if let imageName = selectedImage {
            if let size = imageView.image?.size {
                
                let renderer = UIGraphicsImageRenderer(size: size)
                
                let image = renderer.image { ctx in
                    let photo = UIImage(named: imageName)
                    photo?.draw(at: CGPoint(x: 0, y: 0))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 36),
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let string = "From Storm Viewer"
                    let attributedString = NSAttributedString(string: string, attributes: attrs)
                    
                    attributedString.draw(with: CGRect(x: size.width / 6, y: size.height / 2, width: size.width, height: size.height), options: .usesLineFragmentOrigin, context: nil)
                }
                return image
            }
        }
        
        fatalError("Image could not be rendered properly.")
    }
}
