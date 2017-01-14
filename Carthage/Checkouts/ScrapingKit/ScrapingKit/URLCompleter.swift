//
//  URLCompleter.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

class URLCompleter {
    class func completeUrlIfNeeded(baseUrl: URL?, targetUrl: String) -> String {
        return targetUrl.hasPrefix("/") ? concatHomePrefix(to: targetUrl, baseUrl: baseUrl) ?? targetUrl : targetUrl
    }
    
    private class func concatHomePrefix(to target: String, baseUrl: URL?) -> String? {
        let path = target.hasPrefix("/") ? target : "/\(target)"
        return homeUrl(from: baseUrl).flatMap { "\($0)\(path)" }
    }
    
    private class func homeUrl(from baseUrl: URL?) -> String? {
        guard let baseUrl = baseUrl else { return nil }
        return baseUrl.host.flatMap { "\(baseUrl.scheme)://\($0)" } ?? nil
    }
}
