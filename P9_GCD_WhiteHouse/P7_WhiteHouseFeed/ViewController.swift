//
//  ViewController.swift
//  P7_WhiteHouseFeed
//
//  Created by Laura on 16.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var petitions         = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString) {               // convert to url
                if let data = try? Data(contentsOf: url) {      // fetch from API
                    
                    self?.parse(json: data)                     // parse means self.parse so needs to be weak captured bc this is a closure
                    return
                }
            }
            self?.showError()
        }
        
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a connection problem loading the feed, please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()                                                    // decodes JSON into objects of our choosing

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {       // asks decoder to convert its data into a single petitions object (Petitons.self)
            petitions = jsonPetitions.results                                          // .results matches exact name in JSON
            filteredPetitions = jsonPetitions.results
            
            DispatchQueue.main.async {  [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func filterPetitions() {
        let filterAlert = UIAlertController(title: "Search engine", message: nil, preferredStyle: .alert)
       
        filterAlert.addTextField()
        filterAlert.addAction(UIAlertAction(title: "Search", style: .default) {
            [weak self, weak filterAlert] _ in
            guard let stringToSearch = filterAlert?.textFields?[0].text else { return }
            self?.search(filterInput: stringToSearch)
        })
        
        filterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(filterAlert, animated: true)
    }
    
    func search(filterInput: String) {
        filteredPetitions = filteredPetitions.filter { $0.title.contains(filterInput) || $0.body.contains(filterInput) }
        tableView.reloadData()
    }
    
    @objc func showCredit() {
        let creditAlert = UIAlertController(title: "Credits", message: "This data comes from We The People API of the Whitehouse", preferredStyle: .alert)
        
        creditAlert.addAction(UIAlertAction(title: "Got it", style: .default))
        present(creditAlert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        let petition = petitions[indexPath.row]
//        cell.textLabel?.text       = petition.title
//        cell.detailTextLabel?.text = petition.body
        
        let filtered = filteredPetitions[indexPath.row]
        cell.textLabel?.text = filtered.title
        cell.detailTextLabel?.text = filtered.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()                                         // directly, no storyboards
        detailVC.detailItem = petitions[indexPath.row]                                // whichever user taps
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

