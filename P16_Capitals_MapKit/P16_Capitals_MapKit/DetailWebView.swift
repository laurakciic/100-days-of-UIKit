//
//  DetailWebView.swift
//  P16_Capitals_MapKit
//
//  Created by Laura on 29.08.2022..
//

import UIKit
import WebKit

class DetailWebView: UIViewController, WKNavigationDelegate {

    @IBOutlet var detailWebView: WKWebView!
    var city: String?
    
    override func loadView() {
        detailWebView = WKWebView()
        detailWebView.navigationDelegate = self
        view = detailWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let wikiUrl = "https://en.wikipedia.org/wiki/"
        
        let url = URL(string: wikiUrl + city!)!
        detailWebView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        title = webView.title
    }
}
