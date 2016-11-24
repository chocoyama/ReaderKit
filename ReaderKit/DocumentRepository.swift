//
//  DocumentRepository.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

open class DocumentRepository {
    private init() {}
    open static let shared = DocumentRepository()
    fileprivate let documentProvider = DocumentProvider.init()
    
    // WARNING: 件数によってめっちゃ重くなる
//    open var subscribedDocuments: [Document] {
//        do {
//            let realm = try Realm()
//            let result = realm.objects(RealmDocument.self)
//            
//            var documents = [Document]()
//            result.forEach {
//                if let document = $0.toDocument() {
//                    documents.append(document)
//                }
//            }
//            return documents
//        } catch let error {
//            print(error.localizedDescription)
//            return []
//        }
//    }
    
    open func recent(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [ weak self] (error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            let document = self?.get(link)
            completion(document)
        }
    }
    
    open func get(_ link: URL) -> Document? {
        do {
            let realmDocument = try getRealmDocument(from: link)
            var documentItems: [Document.Item] = []
            realmDocument.items
                .flatMap{ $0.toDocumentItem() }
                .forEach{ documentItems.append($0) }
            
            let document = Document(title: realmDocument.title, link: link, items: documentItems)
            return document
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    open func recent(to: Int, completion: @escaping (_ items: [Document.Item]) -> Void) {
        fetchAll { [weak self] in
            let items = self?.get(from: 0, to: to) ?? []
            completion(items)
        }
    }
    
    open func get(from: Int, to: Int) -> [Document.Item] {
        do {
            let realmDocumentItems = try getRealmDocumentItems(from: from, to: to)
            var documentItems: [Document.Item] = []
            realmDocumentItems
                .flatMap{ $0.toDocumentItem() }
                .forEach{ documentItems.append($0) }
            return documentItems
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    open var subscribedDocumentSummaries: [DocumentSummary] {
        do {
            let realm = try Realm()
            let result = realm.objects(RealmDocument.self)
            
            var summaries = [DocumentSummary]()
            result.forEach {
                if let summary = $0.toDocumentSummary() {
                    summaries.append(summary)
                }
            }
            return summaries
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    open func unsubscriveAll() throws {
        do {
            Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            throw error
        }
    }
    
}

extension DocumentRepository {
    
    internal func fetch(_ link: URL, completion: @escaping (_ error: Error?) -> Void) {
        documentProvider.get(from: link, handler: { [weak self] (document, error) in
            guard let document = document else {
                completion(NSError.init(domain: "", code: 0, userInfo: nil))
                return
            }
            DispatchQueue.main.async {
                do {
                    try self?.update(document)
                    completion(nil)
                } catch let error {
                    completion(error)
                }
            }
        })
    }
    
    internal func fetchAll(completion: @escaping () -> Void) {
        let summaries = subscribedDocumentSummaries
        
        let group = DispatchGroup()
        summaries.forEach {
            group.enter()
            fetch($0.link, completion: { _ in
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    internal func update(_ document: Document) throws {
        do {
            let realm = try Realm()
            if let realmDocument = try? getRealmDocument(from: document.link) {
                let realmItems = document.realmItems
                let newItems = realmItems.filter { !realmDocument.itemIds.contains($0.id) }
                try realm.write {
                    realmDocument.items.append(objectsIn: newItems)
                }
            } else {
                try realm.write {
                    realm.add(document.toRealmObject(), update: true)
                }
            }
        } catch let error {
            throw error
        }
    }
    
    fileprivate func getRealmDocument(from link: URL) throws -> RealmDocument {
        do {
            let realm = try Realm()
            let result = realm.objects(RealmDocument.self).filter("link = '\(link)'")
            if let document = result.first {
                return document
            } else {
                throw NSError.init(domain: "", code: 0, userInfo: nil)
            }
        } catch let error {
            throw error
        }
    }
    
    fileprivate func getRealmDocumentItems(from: Int, to: Int) throws -> [RealmDocumentItem] {
        do {
            let realm = try Realm()
            let result = realm.objects(RealmDocumentItem.self).sorted(byProperty: "date", ascending: false)
            return result.enumerated().filter({ (offset, element) -> Bool in
                return from <= offset && offset < to
            }).map{ $0.element }
        } catch let error {
            throw error
        }
    }
    
}
