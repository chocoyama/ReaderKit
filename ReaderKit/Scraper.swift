//
//  Scraper.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/06.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

//import Ji
//import ImageDissector
//
//open class Scraper {
//    
//    fileprivate var url: URL?
//    fileprivate var images = [Image]()
//    private var jiDoc: Ji?
//    private let dissector = ImageDissector()
//    
//    func set(url: URL) {
//        self.url = url
//        self.jiDoc = Ji(htmlURL: url)
//    }
//    
//    func getImages(fetchSize: Bool, completion: @escaping ([Image]) -> Void) {
//        DispatchQueue.global().async { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.images = []
//            let bodyNodes = strongSelf.jiDoc?.xPath("//body")?.first
//            strongSelf.parse(bodyNodes)
//            
//            if fetchSize == false {
//                DispatchQueue.main.async {
//                    completion(strongSelf.images)
//                }
//                return
//            }
//            
//            strongSelf.dissector.dissectImage(with: strongSelf.images) { (resultImages) in
//                DispatchQueue.main.async {
//                    completion(resultImages)
//                }
//            }
//        }
//    }
//}
//
//// MARK:- helper
//extension Scraper {
//    fileprivate func parse(_ jiNode: JiNode?) {
//        if jiNode?.hasChildren == true {
//            jiNode?.children.forEach{ parse($0) }
//            return
//        }
//        appendImageAtImgTag(jiNode)
//        appendImageAtAnchorTag(jiNode)
//    }
//    
//    private func appendImageAtImgTag(_ jiNode: JiNode?) {
//        guard let _ = jiNode?.attributes["src"], jiNode?.tag == "img" else {
//            return
//        }
//        
//        let destinationUrlString = extractHrefFromAnchor(jiNode: jiNode?.parent)
//        if let url = destinationUrlString , url.hasImageSuffix {
//            append(imageUrlString: url, destinationUrlString: nil)
//        } else if let imageUrlString = extractSrcFromImg(jiNode: jiNode) {
//            append(imageUrlString: imageUrlString, destinationUrlString: destinationUrlString)
//        }
//    }
//    
//    private func appendImageAtAnchorTag(_ jiNode: JiNode?) {
//        if let url = extractHrefFromAnchor(jiNode: jiNode), url.hasImageSuffix {
//            append(imageUrlString: url, destinationUrlString: nil)
//        }
//    }
//    
//    private func append(imageUrlString: String, destinationUrlString: String?) {
//        // TODO: 暫定対応中（以下のURLどちらも対応するため）
//        // http://ord.yahoo.co.jp/o/image/_ylt=A2RivclnwRpXNW4AFE.U3uV7/SIG=11ufrp1k9/EXP=1461457639/**https%3a//t.pimg.jp/000/877/514/1/877514.jpg
//        // http://bijodai.grfft.jp/uploads/model/profile/杉山さん21_s.jpg
//        let imageUrl = imageUrlString.encodeIfOnlySingleByteCharacter()
//        let isExistsUrl = images.contains{ $0.imageUrlString == imageUrl }
//        if !isExistsUrl {
//            images.append(.init(
//                imageUrlString: imageUrl,
//                destinationUrlString: destinationUrlString?.encodeIfOnlySingleByteCharacter())
//            )
//        }
//    }
//}
//
//extension Scraper {
//    private var homeUrl: String? {
//        guard let url = url else { return nil }
//        return url.host.flatMap{ "\(url.scheme)://\($0)" } ?? nil
//    }
//    
//    fileprivate func extractSrcFromImg(jiNode: JiNode?) -> String? {
//        guard let src = jiNode?.attributes["src"], jiNode?.tag == "img" else { return nil }
//        return createCompleteUrlString(urlString: src)
//    }
//    
//    fileprivate func extractHrefFromAnchor(jiNode: JiNode?) -> String? {
//        guard let href = jiNode?.attributes["href"], jiNode?.tag == "a" else { return nil }
//        return createCompleteUrlString(urlString: href)
//    }
//    
//    fileprivate func createCompleteUrlString(urlString: String) -> String? {
//        return urlString.hasPrefix("/") ? concatHomePrefix(to: urlString) : urlString
//    }
//    
//    fileprivate func concatHomePrefix(to pathString: String) -> String? {
//        let path = pathString.hasPrefix("/") ? pathString : "/\(pathString)"
//        return homeUrl.flatMap{ "\($0)\(path)" }
//    }
//}
