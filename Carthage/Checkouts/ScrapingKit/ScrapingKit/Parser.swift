//
//  Parser.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

public protocol Parser {
    associatedtype Result
    associatedtype Configuration
    
    var configuration: Configuration? { get set }
    
    init()
    init(_ configuration: Configuration?)
    
    func parse(_ url: URL)
    func getResult(completion: @escaping (Result) -> Void)
}

open class AnyParser<T: Parser> {
    public var configuration: T.Configuration?
    open let parse: (_ url: URL) -> Void
    open let getResult: (@escaping (T.Result) -> Void) -> Void
    
    public init(_ parser: T) {
        self.configuration = parser.configuration
        self.parse = parser.parse
        self.getResult = parser.getResult
    }
}
