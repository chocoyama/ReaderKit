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
    
    open var subscribedDocuments: [Document] {
        do {
            let realm = try Realm()
            let result = realm.objects(RealmDocument.self)
            
            var documents = [Document]()
            result.forEach {
                if let document = $0.toDocument() {
                    documents.append(document)
                }
            }
            return documents
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    open func recent(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [ weak self] (error) in
            guard let strongSelf = self, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let document = try strongSelf.get(link)
                completion(document)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    open func unsubscriveAll() throws {
        do {
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
    
    internal func get(_ link: URL) throws -> Document {
        do {
            let realmDocument = try getRealmDocument(from: link)
            var documentItems = [DocumentItem]()
            for realmItem in realmDocument.items {
                if let documentItem = realmItem.toDocumentItem() {
                    documentItems.append(documentItem)
                }
            }
            
            let document = Document(title: realmDocument.title, link: link, items: documentItems)
            return document
        } catch let error {
            throw error
        }
    }
    
    internal func update(_ document: Document) throws {
        do {
            let realm = try Realm()
            if let realmDocument = try? getRealmDocument(from: document.link) {
                let newItems = document.realmItems.filter{
                    !realmDocument.itemIds.contains($0.id)
                }
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
            let result = realm.objects(RealmDocument.self).filter("link = '\(link.absoluteString)'")
            if let document = result.first {
                return document
            } else {
                throw NSError.init(domain: "", code: 0, userInfo: nil)
            }
        } catch let error {
            throw error
        }
    }
    
}
