//
//  ViewController.swift
//  C6_Meme_Generation
//
//  Created by Laura on 01.09.2022..
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let importBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        let shareBtn  = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.rightBarButtonItems = [importBtn, shareBtn]
    }
    
    @objc private func importImage(_ sender: Any) {
        let picker           = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate      = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        
        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = 1
        }
        dismiss(animated: true)
    }
    
    private enum TextPosition {
        case top, bottom
    }
    
    @IBAction func addTopText(_ sender: Any) {
        askForTextInput(on: .top)
    }
    
    @IBAction func addBottomText(_ sender: Any) {
        askForTextInput(on: .bottom)
    }
    
    private func askForTextInput(on position: TextPosition) {
        if imageView.image != nil {
            
            let ac = UIAlertController(title: "Text on \(position)", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] action in
                guard let text = ac.textFields?[0].text else { return }
                self?.render(text: text, on: position)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "No image selected", message: "Please import an image first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default))
            present(ac, animated: true)
        }
    }
    
    private func render(text: String, on: TextPosition) {
        let renderer = UIGraphicsImageRenderer(size: imageView.image!.size)
        
        // create & render an image for the context obj
        let renderedImage = renderer.image { ctx in
            imageView.image?.draw(at: CGPoint(x: 0, y: 0))  // draw initial image
            
            let paragraphStyle = NSMutableParagraphStyle()  // center text
            paragraphStyle.alignment = .center
            
            let shadowStyle = NSShadow()                    // enhance readability
            shadowStyle.shadowColor  = UIColor.white
            shadowStyle.shadowOffset = CGSize(width: 5, height: 5)
            
            // make a dict of settings
            let attr: [NSAttributedString.Key: Any] = [
                .backgroundColor: UIColor.white,
                .paragraphStyle:  paragraphStyle,
                .font:            UIFont(name: "Arial", size: 99)!,
                .shadow:          shadowStyle
            ]
            
            let attrText = NSAttributedString(string: text, attributes: attr)
            
            let x = imageView.image?.size.width
            let y = imageView.image?.size.height
            
            if on == .top {
                attrText.draw(with: CGRect(x: 0, y: 0, width: x!, height: y!), options: .usesLineFragmentOrigin, context: nil)
            } else if on == .bottom {
                attrText.draw(with: CGRect(x: 0, y: y! - 99, width: x!, height: y!), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        // display image created from the renderer
        imageView.image = renderedImage
    }
    
    @objc private func shareImage() {
        guard let imageToSend = imageView.image else { return }
        
        let ac = UIActivityViewController(activityItems: [imageToSend], applicationActivities: nil)
        present(ac, animated: true)
    }

}

