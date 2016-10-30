//
//  ReaderKitTestsResources.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/30.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

struct ReaderKitTestsResources {
    static let atomSiteUrl = URL(string: "http://himaratsu.hatenablog.com/")!
    
    static let rss1_0url = URL(string: "https://www.nttdocomo.co.jp/info/rss/whatsnew.rdf")!
    static let rss2_0url = URL(string: "http://himaratsu.hatenablog.com/rss")!
    static let atomurl = URL(string: "http://himaratsu.hatenablog.com/feed")!
    static var rss1_0data: Data { return try! Data.init(contentsOf: rss1_0url) }
    static var rss2_0data: Data { return try! Data.init(contentsOf: rss2_0url) }
    static var atomdata: Data { return try! Data.init(contentsOf: atomurl) }
    
    static var contentsPage = URL(string: "http://vipsister23.com/archives/8629268.html")!
}

