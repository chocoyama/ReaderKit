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
    
    private let url: URL
    private var homeUrl: String? {
        return url.host.flatMap{ "\(url.scheme)://\($0)" } ?? nil
    }
    
    private var images = [Image]()
    
    init(with url: URL) {
        self.url = url
    }
    
    func getImages() -> [Image] {
        images = []
        let jiDoc = Ji(htmlURL: url)
        let bodyNodes = jiDoc?.xPath("//body")?.first
        parse(bodyNodes)
        return images
    }

    private func parse(_ jiNode: JiNode?) {
        if jiNode?.hasChildren == true {
            jiNode?.children.forEach{ parse($0) }
            return
        }
        appendDataIfImageTag(jiNode)
        appendDataIfImageSuffix(jiNode)
    }
    
    private func appendDataIfImageTag(_ jiNode: JiNode?) {
        guard let src = jiNode?.attributes["src"], jiNode?.tag == "img" else {
            return
        }
        
        var destinationUrlString: String? = nil
        if let href = jiNode?.parent?.attributes["href"] , jiNode?.parent?.tag == "a" {
            if href.hasPrefix("http") {
                destinationUrlString = href
            } else if href.hasPrefix("/") {
                destinationUrlString = concatHomePrefix(to: href)
            }
        }
        
        if let url = destinationUrlString , url.hasImageSuffix {
            append(imageUrlString: url, destinationUrlString: nil)
        } else {
            if src.hasPrefix("http") {
                append(imageUrlString: src, destinationUrlString: destinationUrlString)
            } else if let urlString = concatHomePrefix(to: src), src.hasPrefix("/") {
                append(imageUrlString: urlString, destinationUrlString: destinationUrlString)
            }
        }
    }
    
    private func appendDataIfImageSuffix(_ jiNode: JiNode?) {
        if let href = jiNode?.attributes["href"] , jiNode?.tag == "a" && href.hasImageSuffix {
            append(imageUrlString: href, destinationUrlString: nil)
        }
    }
    
    private func append(imageUrlString: String, destinationUrlString: String?) {
        // TODO: 暫定対応中（以下のURLどちらも対応するため）
        // http://ord.yahoo.co.jp/o/image/_ylt=A2RivclnwRpXNW4AFE.U3uV7/SIG=11ufrp1k9/EXP=1461457639/**https%3a//t.pimg.jp/000/877/514/1/877514.jpg
        // http://bijodai.grfft.jp/uploads/model/profile/杉山さん21_s.jpg
        let imageUrl = (imageUrlString.containsDoubleByteCharacter) ? imageUrlString : imageUrlString.encode(CharacterSet.urlFragmentAllowed)
        var destinationUrl: String?
        if let destinationUrlString = destinationUrlString {
            destinationUrl = (destinationUrlString.containsDoubleByteCharacter) ? destinationUrlString : destinationUrlString.encode(CharacterSet.urlFragmentAllowed)
        }
        
        let isExistsUrl = images.contains{ $0.imageUrl == imageUrl }
        if !isExistsUrl {
            images.append(.init(imageUrl: imageUrl, destinationUrl: destinationUrl))
        }
    }
    
    private func concatHomePrefix(to pathString: String) -> String? {
        let path = pathString.hasPrefix("/") ? pathString : "/\(pathString)"
        return homeUrl.flatMap{ "\($0)\(path)" }
    }
}

extension String {
    var hasImageSuffix: Bool {
        return (self.hasSuffix(".png") || self.hasSuffix(".jpg") || self.hasSuffix(".jpeg") || self.hasSuffix(".gif"))
    }
    
    var containsDoubleByteCharacter: Bool {
        return NSString(string: self).canBeConverted(to: String.Encoding.ascii.rawValue)
    }
    
    func encode(_ charSet: CharacterSet) -> String {
        return self.addingPercentEncoding(withAllowedCharacters: charSet)!
    }
}
