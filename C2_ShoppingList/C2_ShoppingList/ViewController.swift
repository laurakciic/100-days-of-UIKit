//
//  ViewController.swift
//  C2_ShoppingList
//
//  Created by Laura on 13.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList))
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(start))
        
        start()
    }
    
    @objc func start() {
        title = "Shopping List"
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }

    @objc func addToList() {
        let enterAlert = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        enterAlert.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak enterAlert] _ in
            guard let input = enterAlert?.textFields?[0].text else { return }
            self?.submitInput(input)
        }
        
        enterAlert.addAction(submitAction)
        present(enterAlert, animated: true)
    }
    
    func submitInput(_ input: String) {
        
    }
    

}

