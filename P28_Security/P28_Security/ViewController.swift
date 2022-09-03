//
//  ViewController.swift
//  P28_Security
//
//  Created by Laura on 03.09.2022..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var secretTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"

        configureKeyboardObservers()
    }
    
    private func configureKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }   // size of keyboard
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue                                // concrete size of keyboard (relative to the screen - doesn't take rotation into account)
        let keyboardViewEndFrame   = view.convert(keyboardScreenEndFrame, from: view.window)  // correct size of keyboard in rotated screen space
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretTextView.contentInset = .zero                                               // textView takes up all available space (the amount of push to text in from its edges)
        } else {                            // if in didChangeFrame
            secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)  // size of keyboard's height rotated for our window
        }                                                                    // compensate for the safe area existing with at home indicator on 10 class devices - 0 on Iphone SE, 8..
        
        secretTextView.scrollIndicatorInsets = secretTextView.contentInset   // how much margins apply to little scrollbar on the right edge of textViews when they scroll - match the size of textView
        
        // make textView scroll down to show whatever user tapped on
        let selectedRange = secretTextView.selectedRange
        secretTextView.scrollRangeToVisible(selectedRange)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
    }
    
}

