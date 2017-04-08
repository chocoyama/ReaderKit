//
//  SubscribeTests.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//
import XCTest
@testable import ReaderKit
import Realm
import RealmSwift

class SubscribeTests: XCTestCase {
    
    private let reader = Reader.init()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        deleteAll()
        super.tearDown()
    }
    
    private func deleteAll() {
        let result = DocumentRepository.shared.unsubscriveAll()
        if result != nil {
            XCTFail()
        }
    }
    
    func testDeleteAll() {
        let result = DocumentRepository.shared.unsubscriveAll()
        if result != nil {
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
            if result != nil {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testUnsubscribe() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let _ = DocumentRepository.shared.subscribe(thinkBigActLocal)
        XCTAssertEqual(DocumentRepository.shared.subscribedDocumentCount, 1)
        let _ = DocumentRepository.shared.unsubscribe(thinkBigActLocal)
        XCTAssertEqual(DocumentRepository.shared.subscribedDocumentCount, 0)
    }
    
    func testSubscribed() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let link = thinkBigActLocal.link
        let _ = DocumentRepository.shared.subscribe(thinkBigActLocal)
        XCTAssertTrue(DocumentRepository.shared.checkSubscribed(link: link))
        let _ = DocumentRepository.shared.unsubscribe(thinkBigActLocal)
        XCTAssertFalse(DocumentRepository.shared.checkSubscribed(link: link))
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
            let items = (0..<itemCount).map { (offset) -> DocumentItem in
                let item = DocumentItem()
                item.documentTitle = documentTitle
                item.documentLink = documentUrl.absoluteString
                item.title = "test"
                item.link = urls[offset].absoluteString
                item.desc = "test"
                item.date = Date()
                item.read = false
                return item
            }
            let document = Document()
            document.title = documentTitle
            document.link = documentUrl.absoluteString
            document.items.append(objectsIn: items)
            documents.append(document)
        }
        
        documents.forEach {
            let result = DocumentRepository.shared.subscribe($0)
            if result != nil {
                XCTFail()
            }
        }
        
        self.measure {
            let subscribedCount = DocumentRepository.shared.subscribedDocumentSummaries.count
            XCTAssertTrue(subscribedCount == documentsCount)
        }
    }
    
    func testSubscribeUrl() {
        let expectation = self.expectation(description: "subscribe")
        
        let vipSisterUrl = "http://vipsister23.com"
        DocumentRepository.shared.subscribe(vipSisterUrl) { (error) in
            defer { expectation.fulfill() }
            XCTAssertTrue(error == nil)
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
