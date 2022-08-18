//
//  ViewController.swift
//  P10_NamesToFaces
//
//  Created by Laura on 18.08.2022..
//

import UIKit

// UIImagePickerControllerDelegate - tells us when user chose an image or cancel the picker
// UINavigationControllerDelegate - pointless here, lets us determine user is going backward and forward inside picker
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeve PersonCell.")
        }
        return cell
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true                 // lets users edit pictures they select
        picker.delegate = self                      // sets us as the delegate for the picker, we can want to responnd to msgs from the picker
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }    // attempt to find edited image in dictionary that's passed in and type cast it to UIImage
        
        let imageName = UUID().uuidString   // new image name for disk using UUID, type all by itself, making a new one, and reading its strings straight out of there
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)     // read docs dir for app wherever that be and their hidden secret URL, then append to that filename we just made
    
        if let jpegData = image.jpegData(compressionQuality: 0.8) {         // convert image to JPEG data, 0-1
            try? jpegData.write(to: imagePath)                              // write to disk
        }
        dismiss(animated: true)                                             // dismiss topmost vc, not self
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)  // param userDomainMask clarifies we want that docs dir for our current user, returns an array containing nearly always one thing - users docs dir
        return paths[0]     // so we return first item in there
    }
}

