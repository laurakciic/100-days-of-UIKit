//
//  ViewController.swift
//  P28_Security
//
//  Created by Laura on 03.09.2022..
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secretTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"

        KeychainWrapper.standard.set("password", forKey: "SecretPassword")
        configureObservers()
    }
    
    private func configureObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)    // call saveSecretMessage when user leaves the app
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
    
    func unlockSecretMessage() {
        secretTextView.isHidden = false
        title = "Secret stuff"
        
        secretTextView.text = KeychainWrapper.standard.string(forKey: "SecretMsg") ?? ""            // try loading the key from keychain
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
    }
    
    @objc func saveSecretMessage() {
        guard secretTextView.isHidden == false else { return }                                      // making sure secret is visible before running rest of the code
        navigationItem.rightBarButtonItem = nil
        
        KeychainWrapper.standard.set(secretTextView.text, forKey: "SecretMsg")
        secretTextView.resignFirstResponder()                                                       // make text view stop being active on the screen rn
        secretTextView.isHidden = true                                                              // will show authenticate button behind it
        title = "Nothing to see here"
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()                                                                   // LocalAuthentication context
        var error: NSError?                                                                         // objc form of Swift error type
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {     // don't pass in error itself, but where it is in RAM, pointer
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        //error
                        let ac = UIAlertController(title: "Authentication error", message: "Face not recoginzed; enter password instead.", preferredStyle: .alert)
                        ac.addTextField()
                        let submitPassword = UIAlertAction(title: "Submit", style: .default) {
                            [weak self, weak ac] _ in
                            guard let password = ac?.textFields?[0].text else { return }
                            
                            if password == KeychainWrapper.standard.string(forKey: "SecretPassword") {
                                self?.unlockSecretMessage()
                            } else {
                                let ac = UIAlertController(title: "Incorrect password", message: nil, preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self?.present(ac, animated: true)
                            }
                        }
                        ac.addAction(submitPassword)
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometric
            let ac = UIAlertController(title: "Biometry unavailable", message: "Device you are currently on does not support biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default))
            present(ac, animated: true)
        }
    }
    
    private func submitPassword() {
        
    }
    
}

