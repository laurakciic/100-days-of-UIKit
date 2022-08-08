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

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm    = FileManager.default                            // will be used to look for files
        let path  = Bundle.main.resourcePath!                    // tell me where I can find images I added to my app
        let items = try! fm.contentsOfDirectory(atPath: path)   // will be an array of strings containing filenames, items is set to the contents of the dir at above path
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                
            }
        }
        pictures.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  // auto completion: numberof
        return pictures.count
    }
    
    // when you need to provide a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)     // To save CPU time and RAM, iOS only creates as many rows as it needs to work by recycling existing ones (when one row moves off the top of the screen, iOS will take it away and put it into a reuse queue ready to be recycled into a new row that comes in from the bottom)
        cell.textLabel?.text = pictures[indexPath.row]      // gives the text label of the cell the same text as a picture in our array
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "Detail" view controller and typecasting it to be DetailViewController
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]  // sets imamge property to whatever is chosen in the table
            
            // push the detail VC onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)    // shows the screen
        }
    }

}

