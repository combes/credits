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
    static let frameworkBundle = Bundle(identifier: "com.credits")
    
    private var HTMLBodyPath: String?
    private var HTMLContentPath: String?
    private var licensePath: String?
    private var licenseArray: NSArray?
    
    var htmlBody: String?
    
    convenience public init?(licensePath: String) {
        guard let bodyPath = LicenseParser.frameworkBundle?.path(forResource: LicenseParser.licenseHTMLBodyFile, ofType: "html") else {
            return nil
        }
        guard let contentPath = LicenseParser.frameworkBundle?.path(forResource: LicenseParser.licenseHTMLContentFile, ofType: "html") else {
            return nil
        }
        self.init(licensePath: licensePath, licenseHTMLBodyPath: bodyPath, licenseHTMLContentPath: contentPath)
    }
    
    public init?(licensePath: String,
                 licenseHTMLBodyPath: String,
                 licenseHTMLContentPath: String) {
        
        if licensePath.isEmpty || licenseHTMLBodyPath.isEmpty || licenseHTMLContentPath.isEmpty { return nil }
        
        HTMLBodyPath = licenseHTMLBodyPath
        HTMLContentPath = licenseHTMLContentPath
        self.licensePath = licensePath
        
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
        
        guard let array = NSArray(contentsOfFile: licensePath!) else {
            throw ParseError.load
        }
        
        licenseArray = array
        
        if licenseArray?.count == 0 { throw ParseError.parse }
    }
    
    private func loadHTMLBody() throws {
        // Load HTML license body
        htmlBody = try String(contentsOfFile: HTMLBodyPath!, encoding: String.Encoding.utf8)
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
            var htmlString = try String(contentsOfFile: HTMLContentPath!, encoding: String.Encoding.utf8)
            
            // Parse title and link attributes
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





