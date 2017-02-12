//
//  CreditsTests.swift
//  Credits
//
//  Created by Christopher Combes on 2/11/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import XCTest

class CreditsTests: XCTestCase {
    
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
        XCTAssertNil(LicenseParser(licensePath: ""), "Empty license path should fail")
        XCTAssertNil(LicenseParser(licensePath: "Bogus Path"), "Bogus license path should fail")
        
        // Load a valid license test file
        guard let path = Bundle(for: CreditsTests.classForCoder()).path(forResource: "licenses-test", ofType: "plist") else {
            XCTFail("Could not find licenses test file")
            return
        }
        
        XCTAssertNotNil(LicenseParser(licensePath: path))
    }
}
