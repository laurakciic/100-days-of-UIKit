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

    var people = [Person]()             // store all people in app, everytime we add a new person, we create a new person obj with their details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        // load the array back from disk when the app runs
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {           // using object(forKey:) to pull out people data and typecast it to Data instance
            let jsonDecoder = JSONDecoder()                                         // instance of JSONDecoder
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)   // give that to instance of JSONDecoder to invert that back to an object graph ie. array of people
            } catch {                                                               // [Person].self - create an array of Person objects from this data 
                print("Failed to load people.")
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeve PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name                // assign person's name to the label text
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)     // call getDocDir and append path comp of the person's image name
        cell.imageView.image = UIImage(contentsOfFile: path.path)    // use above to create UIImage, path.path converts URL to string to satisfy contentsOfFile
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7                 // round the whole cells corners
        
        return cell
    }

    @objc func addNewPerson() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true                 // lets users edit pictures they select
            picker.delegate = self                      // sets us as the delegate for the picker, we can want to responnd to msgs from the picker
            present(picker, animated: true)
        } else
        {
            let alert  = UIAlertController(title: "Warning", message: "Camera available only on physical device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }    // attempt to find edited image in dictionary that's passed in and type cast it to UIImage
        
        let imageName = UUID().uuidString   // new image name for disk using UUID, type all by itself, making a new one, and reading its strings straight out of there
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)     // read docs dir for app wherever that be and their hidden secret URL, then append to that filename we just made
    
        if let jpegData = image.jpegData(compressionQuality: 0.8) {         // convert image to JPEG data, 0-1
            try? jpegData.write(to: imagePath)                              // write to disk
        }
        
        let person = Person(name: "Uknown", image: imageName)               // creates a new person instance
        people.append(person)                                               // to people array
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)                                             // dismiss topmost vc, not self
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)  // param userDomainMask clarifies we want that docs dir for our current user, returns an array containing nearly always one thing - users docs dir
        return paths[0]     // so we return first item in there
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Do you want to rename or delete this item?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: {action in self.renamePerson(alert: ac, indexPath: indexPath)}))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in self.deletePerson(collectionView: collectionView, indexPath: indexPath)}))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    func renamePerson(alert: UIAlertController, indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in                                       // will be passed in so it needs _/action
            guard let newName = ac?.textFields?[0].text else { return }     // read out text fields text and use it for our person's name
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePerson(collectionView: UICollectionView, indexPath: IndexPath) {
        people.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people")
        }
    }
}

