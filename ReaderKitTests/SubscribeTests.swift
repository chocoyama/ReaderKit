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
        do {
            try DocumentRepository.shared.unsubscriveAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteAll() {
        do {
            try DocumentRepository.shared.unsubscriveAll()
        } catch let error {
            XCTFail(error.localizedDescription)
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
            defer { expectation?.fulfill() }
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
            defer { expectation?.fulfill() }
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
                Document.Item.init(
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
            do {
                try $0.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
        self.measure {
            let subscribedCount = DocumentRepository.shared.subscribedDocumentSummaries.count
            XCTAssertTrue(subscribedCount == documentsCount)
        }
    }
}
