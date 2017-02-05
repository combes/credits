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

class LicenseParser {
    static let licensePlist = "licenses"
    static let licenseHTMLBodyFile = "license-body"
    static let licenseHTMLContentFile = "license-content"
    
    private var plistFile: String?
    private var HTMLBodyFile: String?
    private var HTMLContentFile: String?
    private var licenseArray: NSArray?
    
    var htmlBody: String?
    
    init?(licensePlist: String = LicenseParser.licensePlist,
          licenseHTMLBodyFile: String = LicenseParser.licenseHTMLBodyFile,
          licenseHTMLContentFile: String = LicenseParser.licenseHTMLContentFile) {
        
        if licensePlist.isEmpty || licenseHTMLBodyFile.isEmpty || licenseHTMLContentFile.isEmpty { return nil }
        plistFile = licensePlist
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
        guard let licensePath = Bundle.main.path(forResource: plistFile, ofType: "plist") else {
            throw ParseError.load
        }
        
        licenseArray = NSArray(contentsOfFile: licensePath)
        
        if licenseArray?.count == 0 { throw ParseError.parse }
    }
    
    private func loadHTMLBody() throws {
        // Load HTML license body
        guard let htmlPath = Bundle.main.path(forResource: HTMLBodyFile, ofType: "html") else {
            throw ParseError.load
        }
        
        htmlBody = try String(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)
    }
    
    private func buildHTMLContent() throws {
        
        var htmlContent = ""
        
        // For each license parse the title, link and content and build HTML content
        for license in licenseArray! {
            // TODO: Can propertyList be used instead of parsing manually?
            let licenseDictionary = license as! [String:String]
            
            let title = licenseDictionary["title"] ?? ""
            let link = licenseDictionary["link"] ?? ""
            let content = licenseDictionary["content"] ?? ""
            
            // Load HTML content file for iteration through each license
            guard let htmlPath = Bundle.main.path(forResource: "license-content", ofType: "html") else {
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





