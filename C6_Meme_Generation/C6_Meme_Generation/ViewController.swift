//
//  ViewController.swift
//  C6_Meme_Generation
//
//  Created by Laura on 01.09.2022..
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    private var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.alpha = 0
    }

    private func configureUI() {
        title = "Meme Maker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
    }
    
    @objc private func importImage(_ sender: Any) {
        let picker           = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate      = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        
        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = 1
        }
        
        dismiss(animated: true)
    }
}

