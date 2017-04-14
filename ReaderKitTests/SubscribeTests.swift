//
//  SubscribeTests.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

class SubscribeTests: XCTestCase {
    
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
        let result = DocumentRepository.shared.unSubscribeAll()
        if result == false {
            XCTFail()
        }
    }
    
    func testDeleteAll() {
        let result = DocumentRepository.shared.unSubscribeAll()
        if result == false {
            XCTFail()
        }
    }
    
    func testSubscribe() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer { expectation?.fulfill() }
            guard let document = document else {
                XCTFail()
                return
            }
            
            let result = DocumentRepository.shared.subscribe(document)
            if result == false {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUnsubscribe() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer { expectation?.fulfill() }
            guard let document = document else {
                XCTFail()
                return
            }
            
            // 購読してないものを削除
            let result = DocumentRepository.shared.unSubscribe(document)
            XCTAssertFalse(result)
            
            // 購読
            let result2 = DocumentRepository.shared.subscribe(document)
            XCTAssertTrue(result2)
            
            // 購読済みのものを削除
            let result3 = DocumentRepository.shared.unSubscribe(document)
            XCTAssertTrue(result3)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSubscribed() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer { expectation?.fulfill() }
            guard let document = document else {
                XCTFail()
                return
            }
            
            // 購読してない
            XCTAssertFalse(DocumentRepository.shared.isSubscribed(document))
            
            // 購読
            let result = DocumentRepository.shared.subscribe(document)
            if result == false {
                XCTFail()
            }
            XCTAssertTrue(DocumentRepository.shared.isSubscribed(document))
            
            // 購読済みのものを削除
            let result2 = DocumentRepository.shared.unSubscribe(document)
            if result2 == false {
                XCTFail()
            }
            XCTAssertFalse(DocumentRepository.shared.isSubscribed(document))
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testAccessAllSubscribedDocument() {
        let documentsCount = 20
        let documentTitles = (0..<documentsCount).map{ "test\($0)" }
        let documentUrls = (0..<documentsCount).map{ URL(string: "http://google.com/\($0)")! }

        let itemCount = 100
        let urls = (0..<itemCount).map { URL(string: "http://www.yahoo.co.jp/\($0)")! }
        
        var documents = [Document]()
        for offset in (0..<documentsCount) {
            let documentTitle = documentTitles[offset]
            let documentUrl = documentUrls[offset]
            let items = (0..<itemCount).map {
                DocumentItem.init(
                    documentTitle: documentTitle,
                    documentLink: documentUrl,
                    title: "test",
                    link: urls[$0],
                    desc: "test",
                    date: Date.init(),
                    read: false
                )
            }
            let document = Document.init(
                title: documentTitle,
                link: documentUrl,
                items: items
            )
            documents.append(document)
        }
        
        documents.forEach {
            let result = DocumentRepository.shared.subscribe($0)
            if result == false {
                XCTFail()
            }
        }
        
        self.measure {
            let subscribedCount = DocumentRepository.shared.subscribedDocumentSummaries.count
            XCTAssertTrue(subscribedCount == documentsCount)
        }
    }
}
