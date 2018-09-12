//
//  HomeTests.swift
//  iOSTestEokoeUITests
//
//  Created by Fernanda de Lima on 12/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import XCTest
@testable import iOSTestEokoe

class HomeTests: XCTestCase {
    
    var user:Users?
    var start = 1
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadUser() {
        API.get(Users.self, endpoint: .users(start), success: { (users) in
            self.user = users
            XCTAssertTrue(true)
        }) { (error) in
            XCTAssertTrue(false)
        }
    }
    
}
