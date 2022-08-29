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

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // extensionContext - lets us control how to interact with parent app
        // input items - array of data that parent app sends to extension
        // input item  - array of attachments - wrapped as NSItemProvider
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {                            // pull out first attachment from first inputItem
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {   // asks itemProvider to provide us with item, closure - asynchronously
                    [weak self] (dict, error) in                                            // dict - what was provided to us by iOS
                    
                    // do stuff
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
