//
//  CreditsExampleTests.swift
//  CreditsExampleTests
//
//  Created by Christopher Combes on 1/23/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import XCTest
@testable import CreditsExample

class LicenseParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNil(LicenseParser(licensePlist: ""), "Empty plist file should fail")
        XCTAssertNil(LicenseParser(licensePlist: "BogusPlist"), "Bogus plist file should fail")
        XCTAssertNotNil(LicenseParser(), "Parser should not be nil.")
    }
}
