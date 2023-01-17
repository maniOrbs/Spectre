//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/17.
//

import Spectre

public let testFailure: ((ContextType) -> Void) = {
    $0.it("throws an error") {
        var didFail = false
        
        do {
            throw failure("it's broken")
        } catch {
            didFail = true
        }
        
        if !didFail {
            fatalError("Test failed")
        }
    }
}
