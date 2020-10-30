//
//  Adrenaline
//
//  Copyright (c) 2020 Wellington Marthas
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import os
import Foundation

public protocol LogTracingProtocol {
    func end()
    
    func end(_ message: String)
    
    func event(name: StaticString)
}

@available(iOS 12, macOS 10.14, watchOS 5, *)
struct LogTracing {
    @usableFromInline
    let log: OSLog
    
    @usableFromInline
    let name: StaticString
    
    @usableFromInline
    let signpostID: OSSignpostID
    
    @inlinable
    init(log: OSLog, name: StaticString) {
        let signpostID = OSSignpostID(log: log)
        
        self.log = log
        self.name = name
        self.signpostID = signpostID
        
        os_signpost(.begin, log: log, name: name, signpostID: signpostID)
    }
    
    @inlinable
    init(log: OSLog, name: StaticString, message: String) {
        let signpostID = OSSignpostID(log: log)
        
        self.log = log
        self.name = name
        self.signpostID = signpostID
        
        os_signpost(.begin, log: log, name: name, signpostID: signpostID, "%@", message)
        
        #if DEBUG
        os_log(.debug, log: log, "%@", message)
        #endif
    }
}

@available(iOS 12, macOS 10.14, watchOS 5, *)
extension LogTracing: LogTracingProtocol {
    @inlinable
    func end() {
        os_signpost(.end, log: log, name: name, signpostID: signpostID)
    }
    
    @inlinable
    func end(_ message: String) {
        os_signpost(.end, log: log, name: name, signpostID: signpostID, "%@", message)
    }
    
    @inlinable
    func event(name: StaticString) {
        os_signpost(.event, log: log, name: name, signpostID: signpostID)
    }
}
