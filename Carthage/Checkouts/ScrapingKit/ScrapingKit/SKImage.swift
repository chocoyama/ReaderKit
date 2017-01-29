//
//  SKImage.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import ImageDissector

open class SKImage: SizeInjectionable {
    
    open var imageUrlString: String
    open var destinationUrlString: String?
    
    open var imageUrl: URL?
    open var destinationUrl: URL?
    
    open var imageSize: CGSize?
    open var imageType: Type?
    
    public init(imageUrlString: String, destinationUrlString: String?) {
        self.imageUrlString = imageUrlString
        self.imageUrl = URL.init(string: imageUrlString)
        self.destinationUrlString = destinationUrlString
        if let destinationUrlString = destinationUrlString {
            self.destinationUrl = URL.init(string: destinationUrlString)
        }
    }
}
