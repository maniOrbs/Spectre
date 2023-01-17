//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/17.
//

import XCTest

extension XCTestCase {
    
    public func describe(_ name: String, _ closure: (ContextType) -> Void) {
        let context = Context(name: name)
        closure(context)
        context.run(reporter: XcodeReporter(testCase: self))
    }
    
    public func it(_ name: String, closure: @escaping () throws -> Void) {
        let `case` = Case(name: name, closure: closure)
        `case`.run(reporter: XcodeReporter(testCase: self))
    }
}


class XcodeReporter: ContextReporter {
    let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    // MARK: - ContextReporter
    func report(_ name: String, closure: (ContextReporter) -> Void) {
        closure(self)
    }
    
    func addSuccess(_ name: String) {}
    
    func addDisabled(_ name: String) {}
    
    func addFailure(_ name: String, failure: FailureType) {
        #if swift(>=4.2)
        #if compiler(>=5.3) && os(macOS)
        let location = XCTSourceCodeLocation(filePath: failure.file, lineNumber: failure.line)
        #if Xcode
        let issue = XCTIssueReference(type: .assertionFailure, compactDescription: "\(name): \(failure.reason)", detailedDescription: nil, sourceCodeContext: .init(location: location), associatedError: nil, attachments: [])
        #else
        let issue = XCTIssue(type: .assertionFailure, compactDescription: "\(name): \(failure.reason)", detailedDescription: nil, sourceCodeContext: .init(location: location), associatedError: nil, attachments: [])
        #endif
        #if compiler(>=5.4)
        testCase.record(issue as XCTIssue)
        #else
        testCase.record(issue)
        #endif
        #else
        testCase.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
        #endif
        #endif
    }
}
