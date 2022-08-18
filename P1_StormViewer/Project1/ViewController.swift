//
//  ViewController.swift
//  Project1
//
//  Created by Laura on 08.08.2022..
//

/*
 In this instance it’s perfectly fine to use Bundle.main.resourcePath! and try!, because if this code fails it means our app can't read its own data so something must be seriously wrong.
 */

import UIKit

class ViewController: UITableViewController {

    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))
        
        performSelector(inBackground: #selector(loadImages), with: nil)
    }
    
    @objc func loadImages() {
        let fm    = FileManager.default                          // will be used to look for files
        let path  = Bundle.main.resourcePath!                    // tell me where I can find images I added to my app
        let items = try! fm.contentsOfDirectory(atPath: path)    // will be an array of strings containing filenames, items is set to the contents of the dir at path
        
        for item in items {
            if item.hasPrefix("nssl") {
                images.append(item)
            }
        }
        images.sort()
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    // when you need to provide a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = images[indexPath.row]                                                            // gives the text label of the cell the same text as a picture in our array
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {  // try loading "Detail" view controller and typecasting it to be DetailViewController
            vc.selectedImage = images[indexPath.row]                                                            // sets image property to whatever is chosen in the table
            
            vc.selectedImageNumber = indexPath.row + 1
            vc.totalImageCount     = images.count
            
            
            navigationController?.pushViewController(vc, animated: true)                                        // shows the screen, push the detail VC onto the navigation controller 
        }
    }
    
    @objc func recommendApp() {
        
        let shareNote = "Share app with friends!"
        
        let shareNoteAVC = UIActivityViewController(activityItems: [shareNote], applicationActivities: [])
        shareNoteAVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(shareNoteAVC, animated: true)
        
    }

}

