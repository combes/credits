//
//  WebViewController.swift
//  CreditsExample
//
//  Created by Christopher Combes on 1/22/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import Foundation
import WebKit

class WebViewController : UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parse licenses
        if let parser = LicenseParser() {
            // Load webView with final result
            webView.loadHTMLString(parser.htmlBody!, baseURL: nil)
        }
    }
}
