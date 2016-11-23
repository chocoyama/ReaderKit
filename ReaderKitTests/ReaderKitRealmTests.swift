//
//  ReaderKitRealmTests.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/30.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

class ReaderKitRealmTests: XCTestCase {
    
    private let reader = Reader.init()
    
    override func setUp() {
        super.setUp()
        deleteAll()
    }
    
    override func tearDown() {
        deleteAll()
        super.tearDown()
    }
    
    private func deleteAll() {
        do {
            try DocumentRepository.shared.unsubscriveAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRecent() {
        let link = ReaderKitTestsResources.rss1_0url
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        DocumentRepository.shared.recent(link) { (document) in
            defer { expectation?.fulfill() }
            
            if let document = document {
                XCTAssertTrue(document.link == link)
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
}
