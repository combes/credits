//
//  CreditsViewController.swift
//  Credits
//
//  Created by Christopher Combes on 2/11/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import Foundation
import WebKit

public class CreditsViewController : UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    public var parser: LicenseParser?
    
    public static func creditsViewController(parser: LicenseParser) -> CreditsViewController {
        let frameworkBundle = Bundle(identifier: "com.credits")
        let storyboard = UIStoryboard(name: "Storyboard", bundle: frameworkBundle)
        let controller = storyboard.instantiateViewController(withIdentifier: "storyboard") as! CreditsViewController
        controller.parser = parser
        return controller
    }
    
    override public func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // A license parser must be initialized
        assert(parser != nil)

        // Provide a way for the user to cancel
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton

        // Load webView with final result
        webView.loadHTMLString((parser?.htmlBody!)!, baseURL: nil)
    }
    
    func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
