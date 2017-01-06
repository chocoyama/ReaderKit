//
//  Image.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

public struct Image {
    public struct FetchResult {
        public let data: Data
        public let image: UIImage
        public let size: CGSize
    }
    
    private(set) var imageUrl: String
    private(set) var destinationUrl: String?
    public var fetchResult: FetchResult?
    
    init(imageUrl: String, destinationUrl: String?, fetchResult: FetchResult? = nil) {
        self.imageUrl = imageUrl
        self.destinationUrl = destinationUrl
        self.fetchResult = fetchResult
    }
    
    public func fetch(_ completion: @escaping (_ image: Image) -> Void) {
        DispatchQueue.global(qos: .default).async {
            guard let url = URL.init(string: self.imageUrl),
                let imageData = try? Data.init(contentsOf: url),
                let image = UIImage(data: imageData) else {
                    DispatchQueue.main.async {
                        completion(self)
                    }
                    return
            }
            let fetchResult = FetchResult.init(data: imageData, image: image, size: image.size)
            DispatchQueue.main.async {
                let image = Image.init(
                    imageUrl: self.imageUrl,
                    destinationUrl: self.destinationUrl,
                    fetchResult: fetchResult)
                completion(image)
            }
        }
    }
}

