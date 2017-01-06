//
//  Configuration.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

public struct Configuration {
    static let `default` = Configuration.init(saveDocument: true)
    
    var saveDocument: Bool
}
