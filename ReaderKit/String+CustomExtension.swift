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
    
    var hasImageSuffix: Bool {
        return (self.hasSuffix(".png") || self.hasSuffix(".jpg") || self.hasSuffix(".jpeg") || self.hasSuffix(".gif"))
    }
    
    var containsDoubleByteCharacter: Bool {
        return NSString(string: self).canBeConverted(to: String.Encoding.ascii.rawValue)
    }
    
    func encode(_ charSet: CharacterSet) -> String {
        return self.addingPercentEncoding(withAllowedCharacters: charSet)!
    }
    
    // TODO: 暫定対応中（以下のURLどちらも対応するため）
    // http://ord.yahoo.co.jp/o/image/_ylt=A2RivclnwRpXNW4AFE.U3uV7/SIG=11ufrp1k9/EXP=1461457639/**https%3a//t.pimg.jp/000/877/514/1/877514.jpg
    // http://bijodai.grfft.jp/uploads/model/profile/杉山さん21_s.jpg
    func encodeIfOnlySingleByteCharacter() -> String {
        return self.containsDoubleByteCharacter ? self : self.encode(CharacterSet.urlFragmentAllowed)
    }
}

