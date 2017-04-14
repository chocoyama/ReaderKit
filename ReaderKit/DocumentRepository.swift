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
    fileprivate let reader = Reader()
    
    open func recent(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [weak self] (result) in
            guard result == true else {
                completion(nil)
                return
            }
            
            let document = self?.get(link)
            completion(document)
        }
    }
    
    open func recent(to: Int, completion: @escaping (_ items: [DocumentItem]) -> Void) {
        fetchAll { [weak self] in
            let items = self?.get(from: 0, to: to) ?? []
            completion(items)
        }
    }
    
    open func get(_ link: URL) -> Document? {
        guard let realmDocument = RealmManager.makeRealm()?.object(ofType: RealmDocument.self, forPrimaryKey: link.absoluteString) else { return nil }
        var documentItems: [DocumentItem] = []
        realmDocument.items
            .flatMap{ $0.toDocumentItem() }
            .forEach{ documentItems.append($0) }
        return Document(title: realmDocument.title, link: link, items: documentItems)
    }
    
    open func get(from: Int, to: Int) -> [DocumentItem] {
        let realmDocumentItems = RealmManager
                                    .makeRealm()?
                                    .objects(RealmDocumentItem.self)
                                    .sorted(byKeyPath: "date", ascending: false)
                                    .enumerated()
                                    .filter({ (offset, element) -> Bool in
                                        return from <= offset && offset < to
                                    })
                                    .map{ $0.element }
                                    ?? []
        
        var documentItems: [DocumentItem] = []
        realmDocumentItems
            .flatMap{ $0.toDocumentItem() }
            .forEach{ documentItems.append($0) }
        return documentItems
    }
    
    open var subscribedDocumentSummaries: [Document.Summary] {
        guard let result = RealmManager.makeRealm()?.objects(RealmDocument.self) else { return [] }
        
        var summaries = Array<Document.Summary>()
        result.forEach {
            if let summary = $0.toDocumentSummary() {
                summaries.append(summary)
            }
        }
        return summaries
    }
    
}

extension DocumentRepository {
    open func subscribe(_ document: Document) -> Bool {
        guard let realm = RealmManager.makeRealm() else { return false }
        return RealmManager.write(realm: realm) {
            realm.add(document.toRealmObject(), update: true)
        }
    }
    
    open func unSubscribe(_ document: Document) -> Bool {
        guard let realm = RealmManager.makeRealm(),
            let storedDocument = realm.object(ofType: RealmDocument.self, forPrimaryKey: document.id) else { return false }
        
        let success = RealmManager.write(realm: realm) {
            realm.delete(storedDocument.items)
        }
        
        if success == false {
            return false
        }
        
        return RealmManager.write(realm: realm) {
            realm.delete(storedDocument)
        }
    }
    
    open func unSubscribeAll() -> Bool {
        guard let realm = RealmManager.makeRealm() else { return false }
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        return RealmManager.write(realm: realm) {
            realm.deleteAll()
        }
    }
    
    open func isSubscribed(_ document: Document) -> Bool {
        return RealmManager
                .makeRealm()?
                .object(ofType: RealmDocument.self, forPrimaryKey: document.id) != nil
    }
}

extension DocumentRepository {
    internal func fetch(_ link: URL, completion: @escaping (_ result: Bool) -> Void) {
        reader.readNew(link) { [weak self] (document, error) in
            guard let document = document else {
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                let result = self?.update(document) ?? false
                completion(result)
            }
        }
    }
    
    internal func fetchAll(completion: @escaping () -> Void) {
        let summaries = subscribedDocumentSummaries
        
        let group = DispatchGroup()
        summaries.forEach {
            group.enter()
            fetch($0.link) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    internal func update(_ document: Document) -> Bool {
        guard let realm = RealmManager.makeRealm(),
            let realmDocument = realm.object(ofType: RealmDocument.self, forPrimaryKey: document.link.absoluteString) else {
            return subscribe(document)
        }
        
        let newItems = document.realmItems.filter { !realmDocument.itemIds.contains($0.id) }
        return RealmManager.write(realm: realm) {
            realmDocument.items.append(objectsIn: newItems)
        }
    }
    
}
