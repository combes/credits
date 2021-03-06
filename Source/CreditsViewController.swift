//
//  CreditsViewController.swift
//  Credits
//
//  Created by Christopher Combes on 2/11/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import Foundation
import WebKit

public class CreditsViewController : UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    public var parser: LicenseParser?
    
    /**
     Instantiate a `CreditsViewController` for display using a `LicenseParser`.
     
     - Parameter parser: The `LicenseParser` to use.
     - Returns: A new `CreditsViewController`.
     */
    public static func creditsViewController(parser: LicenseParser) -> CreditsViewController {
        let frameworkBundle = Bundle(for: type(of: CreditsViewController()))
        let storyboard = UIStoryboard(name: "Storyboard", bundle: frameworkBundle)
        let controller = storyboard.instantiateViewController(withIdentifier: "storyboard") as! CreditsViewController
        controller.parser = parser
        return controller
    }
    
    override public func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
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
    
    @objc func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // The following code is used to scroll the web view to the top on larger devices.
        // This may be an issue with iOS 10.3 as this issue was not apparent in iOS 10.2.
        // Scroll window to top
        let script = "window.scrollTo(0, -200)"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}
