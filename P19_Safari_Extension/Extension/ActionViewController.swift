//
//  ActionViewController.swift
//  Extension
//
//  Created by Laura on 29.08.2022..
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController, LoaderDelegate {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageUrl   = ""

    // challenge 2
    var savedScriptsByURL = [String: String]()
    
    // challenge 3
    // array of custom objects to instead of a dict to keep order consistent
    var savedScriptsByName = [UserScript]()
    
    // script to load from loadViewController
    var scriptToLoad: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarksTapped))
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // extensionContext - lets us control how to interact with parent app
        // input items - array of data that parent app sends to extension
        // input item  - array of attachments - wrapped as NSItemProvider
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {                            // pull out first attachment from first inputItem
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {   // asks itemProvider to provide us with item, closure - asynchronously
                    [weak self] (dict, error) in                                            // dict - what was provided to us by iOS
                    
                    guard let itemDictionary   = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary [NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageUrl   = javaScriptValues["URL"]   as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    func loadSavedData() {
        // challenge 2
        let defaults = UserDefaults.standard
        savedScriptsByURL = defaults.object(forKey: "savedScripts") as? [String: String] ?? [String: String]()
        
        // challenge 3
        if let savedScriptsByNameData = defaults.object(forKey: "savedScriptsByName") as? Data {
            let jsonDecoder = JSONDecoder()
            savedScriptsByName = (try? jsonDecoder.decode([UserScript].self, from: savedScriptsByNameData)) ?? [UserScript]()
        }
    }
    
    func updateUI() {
        title = "Saved Scripts"
        
        // challenge 2
        if let scriptUrl = URL(string: pageUrl) {
            if let host  = scriptUrl.host {
                script.text = savedScriptsByURL[host]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let scriptToLoad = scriptToLoad {
            script.text = scriptToLoad
        }
        
        scriptToLoad = nil
    }

    @IBAction func done() {
        
        self.saveScriptByURL()
        
        // bundling up to send back to the iOS (Safari)
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
                                            // Notification - includes name of the notif & dict with specific info called UserInfo
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }   // size of keyboard
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue                                // concrete size of keyboard
        let keyboardViewEndFrame   = view.convert(keyboardScreenEndFrame, from: view.window)  // correct size of keyboard in rotated screen space
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero                                                       // textView takes up all available space (the amount of push to text in from its edges)
        } else {                            // if in didChangeFrame
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)  // size of keyboard's height rotated for our window
        }                                                                                     // compensate for the safe area existing with at home indicator on 10 class devices - 0 on Iphone SE, 8..
        
        script.scrollIndicatorInsets = script.contentInset   // how much margins apply to little scrollbar on the right edge of textViews when they scroll - match the size of textView
        
        // make textView scroll down to show whatever user tapped on
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func bookmarksTapped() {
        let ac = UIAlertController(title: "Bookmarks", message: nil, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "Prewritten Scripts", style: .default) { [weak self] _ in
            self?.selectScript()
        })
        ac.addAction(UIAlertAction(title: "Save Script", style: .default) { [weak self] _ in
            self?.saveScriptByURL()
        })
        ac.addAction(UIAlertAction(title: "Load Script", style: .default) { [weak self] _ in
            self?.loadNamedScript()
        })
        
        present(ac, animated: true)
    }
    
    @objc func selectScript() {
        let ac = UIAlertController(title: "Example Scripts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        for (title, body) in scripts {
            ac.addAction(UIAlertAction(title: title, style: .default) {
                [weak self] _ in
                self?.script.text = body
            })
        }
        
        present(ac, animated: true)
    }
    
    @objc func loadNamedScript() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoadViewController") as? LoaderViewController {
            vc.savedScriptsByName = savedScriptsByName
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func saveScriptsByName() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(savedScriptsByName) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedScriptsByName")
        }
    }
    
    // challenge 3
    func loader(_ loader: LoaderViewController, didSelect script: String) {
        scriptToLoad = script

    }
    
    func saveScriptByURL() {
        if let scriptUrl = URL(string: pageUrl) {
            if let host  = scriptUrl.host {
                savedScriptsByURL[host] = script.text
                
                let defaults = UserDefaults.standard
                defaults.set(savedScriptsByURL, forKey: "savedScripts")
            }
        }
    }
}
