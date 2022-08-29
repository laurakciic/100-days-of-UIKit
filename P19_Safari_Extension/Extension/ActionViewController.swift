//
//  ActionViewController.swift
//  Extension
//
//  Created by Laura on 29.08.2022..
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageUrl   = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
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

    @IBAction func done() {
        
        // bundling up to send back to the iOS (Safari)
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }

}
