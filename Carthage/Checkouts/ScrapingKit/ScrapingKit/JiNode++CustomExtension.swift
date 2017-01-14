//
//  JiHelper.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import Ji

extension JiNode {
    internal func extract(attributes: String, at tag: String) -> String? {
        if let result = self.attributes[attributes], self.tag == tag {
            return result
        } else {
            return nil
        }
    }
}

