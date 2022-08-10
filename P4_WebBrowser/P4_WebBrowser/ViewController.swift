//
//  ViewController.swift
//  P4_WebBrowser
//
//  Created by Laura on 10.08.2022..
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        
        let alert = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        alert.addAction(UIAlertAction(title: "hackingwithswift.comm", style: .default, handler: openPage))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem  // attach to iPads
        present(alert, animated: true)
    }
    
    func openPage(action: UIAlertAction) {                                    // selected by user
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return } // created new url combining https and title from alert
        webView.load(URLRequest(url: url))                                    // wraps url insided URL Req and that inside webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

}

