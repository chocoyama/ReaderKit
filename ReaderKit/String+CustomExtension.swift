//
//  String+CustomExtension.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
