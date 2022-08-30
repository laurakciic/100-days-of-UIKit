//
//  DetailViewController.swift
//  C5_iOS_Notes
//
//  Created by Laura on 30.08.2022..
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var notes = [Note]()
    var note: Note?
    var noteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboardObservers()
    }
    
    private func configureKeyboardObservers() {
        
        // resize the textView when the keyboard shows or hides
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        // UIResponder.keyboardFrameEndUserInfoKey is the frame of the keyboard when its animation has finished
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                
        // We take the size of the last frame of the kayboard (CGRect containing CGPoint and CGSize)
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
            
        // We need to convert the CGRect of the keyboard to our view's coordinate (Fix if the user rotate the device)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
                
        // If the keyboard has finished hiding the content inset of textView will be 0
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            // Fix the scrolling indicator to not go below the keyboard
            textView.scrollIndicatorInsets = .zero
                    
            // Hide done button when hiding keyboard
            navigationItem.setRightBarButton(nil, animated: true)
        } else {
            // If the keyboard is not hiding (it's visible) the bottom of the content inset will be the height of the keyboard
            textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 5.00, right: 20)
            // Fix the scrolling indicator to not go below the keyboard
            textView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
                    
            // Show Done button when showing keyboard
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(noteDone)), animated: true)
        }
                
        // selectedRange is where is the cursor
        let selectedRange = textView.selectedRange
        // Scroll the view to the cursor
        textView.scrollRangeToVisible(selectedRange)
        
//        // UIResponder.keyboardFrameEndUserInfoKey - frame of the keyboard when its animation has finished
//        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        let keyboardScreenEndFrame = keyboardValue.cgRectValue  // size of the last frame of the keyboard (CGRect containing CGPoint and CGSize)
//
//        // convert CGRect of the keyboard to our view's coordinate (fix if the user rotates the device)
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            textView.contentInset = .zero
//
//            // hide done button when hiding keyboard
//            //navigationItem.setRightBarButton(nil, animated: true)
//        } else {
//            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//
//            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(noteDone)), animated: true)
//        }
//
//        textView.scrollIndicatorInsets = textView.contentInset
//
//        let selectedRange = textView.selectedRange              // selectedRange is where is the cursor is
//        textView.scrollRangeToVisible(selectedRange)            // scroll the view to the cursor
    }
    
    @objc private func noteDone() {
        
        // Add note to the array of notes then save it
        if note != nil {
            note?.title = textView.text
            notes[noteIndex!] = note!
            saveNote()
        } else if textView.text.count > 1 {
            let newNote = Note(title: textView.text, body: textView.text)
            notes.append(newNote)
            saveNote()
        }
        
        // Go back to the first view controller in the navigation stack
        navigationController?.popViewController(animated: true)
    }
    
    private func saveNote() {
        let jsonEncoder = JSONEncoder()

        if let savedNotes = try? jsonEncoder.encode(notes) {
            UserDefaults.standard.set(savedNotes, forKey: "savedNotes")
        } else {
            fatalError("Unable to save note.")
        }
    }
}
