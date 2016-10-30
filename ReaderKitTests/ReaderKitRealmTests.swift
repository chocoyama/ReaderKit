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
    }
    
    override func tearDown() {
        try! DocumentRepository.shared.deleteAll()
        super.tearDown()
    }
    
    func testDeleteAll() {
        do {
            try DocumentRepository.shared.deleteAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSubscribe() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer {
                expectation?.fulfill()
            }
            guard let document = document else {
                XCTFail()
                return
            }
            
            do {
                try document.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUnsubscribe() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer {
                expectation?.fulfill()
            }
            guard let document = document else {
                XCTFail()
                return
            }
            
            // 購読してないものを削除
            do {
                try document.unSubscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            
            // 購読
            do {
                try document.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            
            // 購読済みのものを削除
            do {
                try document.unSubscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSubscribed() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer {
                expectation?.fulfill()
            }
            guard let document = document else {
                XCTFail()
                return
            }
            
            // 購読してない
            XCTAssertFalse(document.subscribed)
            
            // 購読
            do {
                try document.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertTrue(document.subscribed)
            
            // 購読済みのものを削除
            do {
                try document.unSubscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertFalse(document.subscribed)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
