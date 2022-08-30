//
//  ViewController.swift
//  C5_iOS_Notes
//
//  Created by Laura on 30.08.2022..
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    var notesIndex: Int?
    
    // if there are saved notes load them
    override func viewWillAppear(_ animated: Bool) {
        performSelector(inBackground: #selector(loadNotes), with: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureToolBar()
    }
    
    private func configureToolBar() {
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
    }
    
    @objc private func loadNotes() {
        if let savedNotes = UserDefaults.standard.object(forKey: "savedNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                fatalError("Unable to load notes.")
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func createNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.notes = notes
        }
    }
    
    // delete notes on swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateAfterDelete()
        }
    }
    
    private func updateAfterDelete() {
        let jsonEncoder = JSONEncoder()
        
        if let updatedNotes = try? jsonEncoder.encode(notes) {
            UserDefaults.standard.set(updatedNotes, forKey: "savedNotes")
        } else {
            fatalError("Unable to update notes after deletion.")
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as? NoteCell else { fatalError("Unable to dequeve NoteCell.") }
        cell.noteTitle.text = String(notes[indexPath.row].title.prefix(10))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.notes     = notes
        }
    }
}

