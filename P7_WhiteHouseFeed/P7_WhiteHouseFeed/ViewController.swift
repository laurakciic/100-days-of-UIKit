//
//  ViewController.swift
//  P7_WhiteHouseFeed
//
//  Created by Laura on 16.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString) {               // convert to url
            if let data = try? Data(contentsOf: url) {      // fetch from API
                parse(json: data)
            } else {print("error 1")}
        } else {print("error 2")}
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()                                                    // decodes JSON into objects of our choosing

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {       // asks decoder to convert its data into a single petitions object (Petitons.self)
            petitions = jsonPetitions.results                                          // .results matches exact name in JSON
            print(petitions[0].title)
            tableView.reloadData()
        } else {print("error 3")}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text       = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

}

