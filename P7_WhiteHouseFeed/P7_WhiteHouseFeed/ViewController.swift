//
//  ViewController.swift
//  P7_WhiteHouseFeed
//
//  Created by Laura on 16.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text       = "Title goes here"
        cell.detailTextLabel?.text = "Subtitle goes here"
        return cell
    }

}

