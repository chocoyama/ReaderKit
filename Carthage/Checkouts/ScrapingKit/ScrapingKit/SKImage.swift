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
    open var imageUrl: URL?
    open var imageSize: CGSize?
    
    open var imageUrlString: String
    open var destinationUrlString: String?
    
    public init(imageUrlString: String, destinationUrlString: String?) {
        self.imageUrlString = imageUrlString
        self.imageUrl = URL.init(string: imageUrlString)
        self.destinationUrlString = destinationUrlString
    }
}
