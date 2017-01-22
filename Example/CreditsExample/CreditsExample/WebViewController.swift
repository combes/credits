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
        
        // Load plist file in an array
        var licenseArray: NSArray?
        if let licensePath = Bundle.main.path(forResource: "licenses", ofType: "plist") {
            licenseArray = NSArray(contentsOfFile: licensePath)
        }

        // Load license-content.html
        let htmlPath = Bundle.main.path(forResource: "license-body", ofType: "html")
        var htmlBody = ""
        
        do {
            let htmlString = try String(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
            htmlBody = htmlString
        } catch {
            // TODO: Handle error
        }
        
        var htmlContent = ""
        if let array = licenseArray {
            
            // For each license parse the title and content and embed in the $TITLE and $CONTENT tag of license-content.html
            for license in array {
                // TODO: Can propertyList be used instead of parsing manually?
                let licenseDictionary = license as! [String:String]
                
                let title = licenseDictionary["title"] ?? ""
                let content = licenseDictionary["content"] ?? ""
                
                let htmlPath = Bundle.main.path(forResource: "license-content", ofType: "html")
                
                do {
                    var htmlString = try String(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
                    htmlString = htmlString.replacingOccurrences(of: "$TITLE", with: title)
                    
                    var licenseBody = ""
                    var paragraphBody = ""
                    let range  = content.startIndex ..< content.endIndex
                    content.enumerateSubstrings(in: range, options: .byLines, { (p, _, _, _) in
                        guard let line = p else {return}
                        if line.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                            paragraphBody += line
                        } else {
                            licenseBody += "<p>" + paragraphBody + "</p>" // TODO: HTML wrapping
                            paragraphBody = ""
                        }
                    })
                    
                    if (paragraphBody.lengthOfBytes(using: String.Encoding.utf8) > 0) {
                        licenseBody += "<p>" + paragraphBody + "</p>" // TODO: HTML wrapping
                    }

                    htmlString = htmlString.replacingOccurrences(of: "$CONTENT", with: licenseBody)
                    
                    // Append contents for later usage
                    htmlContent += htmlString
                } catch {
                    // TODO: Handle error
                }
            }
        }
        
        // Replace the $CONTENT of license-body with full content for each license file
        htmlBody = htmlBody.replacingOccurrences(of: "$CONTENT", with: htmlContent)

        // Load webView with final result
        webView.loadHTMLString(htmlBody, baseURL: nil)
    }
}
