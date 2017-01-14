//
//  ImageParser.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import Ji
import ImageDissector

public enum ImageType {
    case gif
    case png
    case jpeg
    case unknown
    
    static func check(_ urlString: String) -> ImageType {
        if urlString.hasSuffix(".gif") {
            return .gif
        } else if urlString.hasSuffix(".png") {
            return .png
        } else if urlString.hasSuffix(".jpeg") || urlString.hasSuffix(".jpg") {
            return .jpeg
        } else {
            return .unknown
        }
    }
}

open class ImageParser: Parser {
    
    public struct ImageParserConfiguration {
        let fetchSize: Bool
        let exclusions: [ImageType]
        
        public init(fetchSize: Bool, exclusions: [ImageType]) {
            self.fetchSize = fetchSize
            self.exclusions = exclusions
        }
    }
    
    public typealias Result = [SKImage]
    public typealias Configuration = ImageParserConfiguration
    public var configuration: ImageParserConfiguration?
    
    fileprivate var url: URL?
    fileprivate var images = [SKImage]()
    private let dissector = ImageDissector()
    
    public required init() {}
    public required init(_ configuration: ImageParserConfiguration?) {
        self.configuration = configuration
    }
    
    open func parse(_ url: URL) {
        self.url = url
        self.images = []
        
        let jiDoc = Ji(htmlURL: url)
        let bodyNodes = jiDoc?.xPath("//body")?.first
        parse(bodyNodes)
    }
    
    public func getResult(completion: @escaping (Array<SKImage>) -> Void) {
        if configuration?.fetchSize == false {
            completion(images)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dissector.dissectImage(with: strongSelf.images) { (resultImages) in
                DispatchQueue.main.async {
                    completion(resultImages)
                }
            }
        }
    }
    
}

extension ImageParser {
    
    fileprivate func parse(_ jiNode: JiNode?) {
        if jiNode?.hasChildren == true {
            jiNode?.children.forEach{ parse($0) }
            return
        }
        appendImageAtImgTag(jiNode)
        appendImageAtAnchorTag(jiNode)
    }
    
    private func appendImageAtImgTag(_ jiNode: JiNode?) {
        guard let src = jiNode?.extract(attributes: "src", at: "img"),
            src.characters.count > 0 else {
            return
        }
        
        let destinationUrlString = jiNode?.extract(attributes: "href", at: "a")
        if let url = destinationUrlString , url.hasImageSuffix {
            append(imageUrlString: url, destinationUrlString: nil)
        } else  {
            append(imageUrlString: src, destinationUrlString: destinationUrlString)
        }
    }
    
    private func appendImageAtAnchorTag(_ jiNode: JiNode?) {
        if let url = jiNode?.extract(attributes: "href", at: "a"), url.hasImageSuffix {
            append(imageUrlString: url, destinationUrlString: nil)
        }
    }
    
    private func append(imageUrlString: String, destinationUrlString: String?) {
        let imageType = ImageType.check(imageUrlString)
        guard configuration?.exclusions.contains(imageType) == false else {
            return
        }
        
        // TODO: 暫定対応中（以下のURLどちらも対応するため）
        // http://ord.yahoo.co.jp/o/image/_ylt=A2RivclnwRpXNW4AFE.U3uV7/SIG=11ufrp1k9/EXP=1461457639/**https%3a//t.pimg.jp/000/877/514/1/877514.jpg
        // http://bijodai.grfft.jp/uploads/model/profile/杉山さん21_s.jpg
        let imageUrl = URLCompleter.completeUrlIfNeeded(
            baseUrl: url,
            targetUrl: imageUrlString
                        .replacingOccurrences(of: "\n", with: "")
                        .encodeIfOnlySingleByteCharacter())
        
        let destinationUrl = destinationUrlString.flatMap{
            URLCompleter.completeUrlIfNeeded(
                baseUrl: url,
                targetUrl: $0
                            .replacingOccurrences(of: "\n", with: "")
                            .encodeIfOnlySingleByteCharacter()
            )
        }
        
        let isExistsUrl = images.contains{ $0.imageUrlString == imageUrl }
        if !isExistsUrl {
            images.append(.init(
                imageUrlString: imageUrl,
                destinationUrlString: destinationUrl
            ))
        }
    }
}

