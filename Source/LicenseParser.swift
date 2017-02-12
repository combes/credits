//
//  LicenseParser.swift
//  CreditsExample
//
//  Created by Christopher Combes on 1/23/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case load
    case parse
}

open class LicenseParser {
    static let titleKey = "title"
    static let linkKey = "link"
    static let contentKey = "content"
    
    static let licensePlist = "licenses"
    static let licenseHTMLBodyFile = "license-body"
    static let licenseHTMLContentFile = "license-content"
    
    private var HTMLBodyFile: String?
    private var HTMLContentFile: String?
    private var licensePath: String?
    private var licenseArray: NSArray?
    private let frameworkBundle = Bundle(identifier: "com.credits")
    
    var htmlBody: String?
    
    public init?(licensePath: String,
                 licenseHTMLBodyFile: String = LicenseParser.licenseHTMLBodyFile,
                 licenseHTMLContentFile: String = LicenseParser.licenseHTMLContentFile) {
        
        if licensePath.isEmpty || licenseHTMLBodyFile.isEmpty || licenseHTMLContentFile.isEmpty { return nil }

        self.licensePath = licensePath
        HTMLBodyFile = licenseHTMLBodyFile
        HTMLContentFile = licenseHTMLContentFile
        
        do {
            try loadLicenses()
            try loadHTMLBody()
            try buildHTMLContent()
        } catch _ {
            return nil
        }
    }

    private func loadLicenses() throws {
        // Load plist file in an array
        
        // TODO: Verify plist path
        // throw ParseError.load
        
        licenseArray = NSArray(contentsOfFile: licensePath!)
        
        if licenseArray?.count == 0 { throw ParseError.parse }
    }

    private func loadHTMLBody() throws {
        // Load HTML license body
        guard let htmlPath = frameworkBundle?.path(forResource: HTMLBodyFile, ofType: "html") else {
            throw ParseError.load
        }
        
        htmlBody = try String(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)
    }
    
    private func buildHTMLContent() throws {
        
        var htmlContent = ""
        
        // For each license parse the title, link and content and build HTML content
        for license in licenseArray! {
            let licenseDictionary = license as! [String:String]
            
            let title = licenseDictionary[LicenseParser.titleKey] ?? ""
            let link = licenseDictionary[LicenseParser.linkKey] ?? ""
            let content = licenseDictionary[LicenseParser.contentKey] ?? ""
            
            // Load HTML content file for iteration through each license
            guard let htmlPath = frameworkBundle?.path(forResource: "license-content", ofType: "html") else {
                throw ParseError.load
            }
            
            // Parse title and link attributes
            var htmlString = try String(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)
            htmlString = htmlString.replacingOccurrences(of: "$TITLE", with: title)
            htmlString = htmlString.replacingOccurrences(of: "$LINK", with: link)
            
            // TODO: This functionality could be moved to an extension
            // Parse content attribute
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
        }
        
        // Replace the $CONTENT of license-body with full content for each license file
        htmlBody = htmlBody?.replacingOccurrences(of: "$CONTENT", with: htmlContent)
    }
}





