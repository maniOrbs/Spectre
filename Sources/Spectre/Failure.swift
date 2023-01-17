//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/17.
//

public protocol FailureType: Error {
    var function: String { get }
    var file: String { get }
    var line: Int { get }
    var reason: String { get }
}

struct Failure: FailureType {
    var function: String
    var file: String
    var line: Int
    var reason: String
    
    init(reason: String, function: String = #function, file: String = #file, line: Int = #line) {
        self.function = function
        self.reason = reason
        self.file = file
        self.line = line
    }
}

struct Skip: Error {
    let reasson: String?
}

public func skip(_ reason: String? = nil) -> Error {
    return Skip(reasson: reason)
}
   

public func failure(_ reason: String? = nil,  function: String = #function, file: String = #file, line: Int = #line) -> FailureType {
    return Failure(reason: reason ?? "-", function: function, file: file, line: line)
}
