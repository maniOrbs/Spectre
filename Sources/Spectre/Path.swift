//
//  File.swift
//  
//
//  Created by 宋璞 on 2023/1/17.
//

import Foundation

/// 路径
struct Path {
    /// 分割字符
    static let separator = "/"
    
    internal let path: String
    internal static let fileMgr = FileManager.default
    
    // MARK: - Init
    
    init() {
        self.init("")
    }
    
    /// Create Path
    init(_ path: String) {
        self.path = path
    }
    
    /// 组合路径
    init<S : Collection>(components: S) where S.Iterator.Element == String {
        let path: String
        if components.isEmpty {
            path = "."
        } else if (components.first == Path.separator && components.count > 1) {
            let p = components.joined(separator: Path.separator)
            path = String(p[p.index(after: p.startIndex)...])
        } else {
            path = components.joined(separator: Path.separator)
        }
        self.init(path)
    }
}

// MARK: - Conversion

extension Path {
    var string: String {
        return self.path
    }
    
    var url: URL {
        return URL(fileURLWithPath: path)
    }
}

// MARK: - Hashable

extension Path: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.path.hashValue)
    }
}

// MARK: - Path Info

extension Path {
    
    public var isAbsolute: Bool {
        return path.hasPrefix(Path.separator)
    }
    
    var isRelative: Bool {
        return !isAbsolute
    }
    
    func absolute() -> Path {
        if isAbsolute {
            return normalize()
        }
        
        let expanededPath = Path(NSString(string: self.path).expandingTildeInPath)
        if expanededPath.isAbsolute {
            return expanededPath.normalize()
        }
        
        return (Path.current + self).normalize()
    }
    
    
    /// 规范路径
    func normalize() -> Path {
        return Path(NSString(string: self.path).standardizingPath)
    }
}


extension Path {
    static var current: Path {
        get {
            return self.init(Path.fileMgr.currentDirectoryPath)
        }
    }
}

extension Path : Equatable {}

func ==(lhs: Path, rhs: Path) -> Bool {
    return lhs.path == rhs.path
}

func ~=(lhs: Path, rhs: Path) -> Bool {
    return lhs == rhs || lhs.normalize() == rhs.normalize()
}

func +(lhs: Path, rhs: Path) -> Path {
    return lhs.path + rhs.path
}

func +(lhs: Path, rhs: String) -> Path {
    return lhs.path + rhs
}

internal func +(lhs: String, rhs: String) -> Path {
    if rhs.hasPrefix(Path.separator) {
        return Path(rhs)
    } else {
        var lSlice = NSString(string: lhs).pathComponents.fullSlice
        var rSlice = NSString(string: rhs).pathComponents.fullSlice
        
        if lSlice.count > 0 && lSlice.last == Path.separator {
            lSlice.removeLast()
        }
        
        lSlice = lSlice.filter { $0 != "." }.fullSlice
        rSlice = rSlice.filter { $0 != "." }.fullSlice
        
        while lSlice.last != ".." && !lSlice.isEmpty && rSlice.first == ".." {
            if lSlice.count > 1 || lSlice.first != Path.separator {
                lSlice.removeLast()
            }
            if !rSlice.isEmpty {
                rSlice.removeFirst()
            }
            
            switch (lSlice.isEmpty, rSlice.isEmpty) {
            case (true, _): break
            case (_, true): break
            case (_, _): continue
            }
        }
        
        return Path(components: lSlice + rSlice)
    }
}


extension Array {
    var fullSlice: ArraySlice<Element> {
        return self[self.indices.suffix(from: 0)]
    }
}
