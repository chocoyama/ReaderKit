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
    private let documentProvider = DocumentProvider.init()
    
    open func get(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [weak self] in
            guard let strongSelf = self,
                let realmDocument = try? strongSelf.getRealmDocument(from: link) else {
                completion(nil)
                return
            }
            
            var documentItems = [DocumentItem]()
            for realmItem in realmDocument.items {
                if let documentItem = realmItem.toDocumentItem() {
                    documentItems.append(documentItem)
                }
            }
            
            let document = Document(title: realmDocument.title, link: link, items: documentItems)
            completion(document)
        }
    }
    
    open func deleteAll() throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            throw error
        }
    }
    
    private func fetch(_ link: URL, completion: @escaping () -> Void) {
        documentProvider.get(from: link, handler: { [weak self] (document, error) in
            DispatchQueue.main.async {
                if let document = document {
                    try? self?.update(document)
                } else {
                    completion()
                }
            }
        })
    }
    
    private func update(_ document: Document) throws {
        do {
            let realm = try Realm()
            if let realmDocument = try? getRealmDocument(from: document.link) {
                let realmItems = document.items.map{ $0.toRealmObject() }
                try realm.write {
                    realmDocument.items.append(objectsIn: realmItems)
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
    
    private func getRealmDocument(from link: URL) throws -> RealmDocument {
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
