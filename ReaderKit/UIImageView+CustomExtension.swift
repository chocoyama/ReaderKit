//
//  UIImageView+CustomExtension.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

public extension UIImageView {
    func set(image: Image) {
        if let fetchResult = image.fetchResult {
            DispatchQueue.main.async {
                self.image = fetchResult.image
            }
        } else {
            image.fetch({ [weak self] (image) in
                DispatchQueue.main.async {
                    self?.image = image.fetchResult?.image
                }
            })
        }
    }
}
