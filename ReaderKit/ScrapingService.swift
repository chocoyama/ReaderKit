//
//  ScrapingService.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import Ji

open class ScrapingService {
    
    fileprivate let url: URL
    fileprivate var images = [Image]()
    private let jiDoc: Ji?
    
    init(with url: URL) {
        self.url = url
        self.jiDoc = Ji(htmlURL: url)
    }
    
    func getImages() -> [Image] {
        images = []
        let bodyNodes = jiDoc?.xPath("//body")?.first
        parse(bodyNodes)
        return images
    }
}

// MARK:- helper
extension ScrapingService {
    fileprivate func parse(_ jiNode: JiNode?) {
        if jiNode?.hasChildren == true {
            jiNode?.children.forEach{ parse($0) }
            return
        }
        appendImageAtImgTag(jiNode)
        appendImageAtAnchorTag(jiNode)
    }
    
    private func appendImageAtImgTag(_ jiNode: JiNode?) {
        guard let _ = jiNode?.attributes["src"], jiNode?.tag == "img" else {
            return
        }
        
        let destinationUrlString = extractHrefFromAnchor(jiNode: jiNode?.parent)
        if let url = destinationUrlString , url.hasImageSuffix {
            append(imageUrlString: url, destinationUrlString: nil)
        } else if let imageUrlString = extractSrcFromImg(jiNode: jiNode) {
            append(imageUrlString: imageUrlString, destinationUrlString: destinationUrlString)
        }
    }
    
    private func appendImageAtAnchorTag(_ jiNode: JiNode?) {
        if let url = extractHrefFromAnchor(jiNode: jiNode), url.hasImageSuffix {
            append(imageUrlString: url, destinationUrlString: nil)
        }
    }
    
    private func append(imageUrlString: String, destinationUrlString: String?) {
        // TODO: 暫定対応中（以下のURLどちらも対応するため）
        // http://ord.yahoo.co.jp/o/image/_ylt=A2RivclnwRpXNW4AFE.U3uV7/SIG=11ufrp1k9/EXP=1461457639/**https%3a//t.pimg.jp/000/877/514/1/877514.jpg
        // http://bijodai.grfft.jp/uploads/model/profile/杉山さん21_s.jpg
        let imageUrl = imageUrlString.encodeIfOnlySingleByteCharacter()
        let isExistsUrl = images.contains{ $0.imageUrl == imageUrl }
        if !isExistsUrl {
            images.append(.init(
                imageUrl: imageUrl,
                destinationUrl: destinationUrlString?.encodeIfOnlySingleByteCharacter())
            )
        }
    }
}

extension ScrapingService {
    private var homeUrl: String? {
        return url.host.flatMap{ "\(url.scheme)://\($0)" } ?? nil
    }
    
    fileprivate func extractSrcFromImg(jiNode: JiNode?) -> String? {
        guard let src = jiNode?.attributes["src"], jiNode?.tag == "img" else { return nil }
        return createCompleteUrlString(urlString: src)
    }
    
    fileprivate func extractHrefFromAnchor(jiNode: JiNode?) -> String? {
        guard let href = jiNode?.attributes["href"], jiNode?.tag == "a" else { return nil }
        return createCompleteUrlString(urlString: href)
    }
    
    fileprivate func createCompleteUrlString(urlString: String) -> String? {
        return urlString.hasPrefix("/") ? concatHomePrefix(to: urlString) : urlString
    }
    
    fileprivate func concatHomePrefix(to pathString: String) -> String? {
        let path = pathString.hasPrefix("/") ? pathString : "/\(pathString)"
        return homeUrl.flatMap{ "\($0)\(path)" }
    }
}
