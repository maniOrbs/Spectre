//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/17.
//

/// Reporter
public protocol Reporter {
    func report(closure: (ContextReporter) -> Void) -> Bool
}

/// 上下文 记录者
public protocol ContextReporter {
    
    func report(_ name: String, closure: (ContextReporter) -> Void)
    
    /// 添加 通过 case
    func addSuccess(_ name: String)
    
    /// 添加 无效 case
    func addDisabled(_ name: String)
    
    /// 添加 失败 case
    func addFailure(_ name: String, failure: FailureType)
}
