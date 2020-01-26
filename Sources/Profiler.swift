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

import Foundation
import os

public struct Profiler {
    public struct Tracing {
        @usableFromInline
        let log: OSLog
        
        @usableFromInline
        let name: StaticString
        
        @usableFromInline
        let id: OSSignpostID
        
        @inlinable
        init(log: OSLog, name: StaticString) {
            self.log = log
            self.name = name
            self.id = OSSignpostID(log: log)
            
            os_signpost(.begin, log: log, name: name, signpostID: id)
        }
        
        @inlinable
        init(log: OSLog, name: StaticString, format: StaticString, arguments: CVarArg...) {
            self.log = log
            self.name = name
            self.id = OSSignpostID(log: log)
            
            os_signpost(.begin, log: log, name: name, signpostID: id, format, arguments)
        }
        
        @inlinable
        public func end() {
            os_signpost(.end, log: log, name: name, signpostID: id)
        }
        
        @inlinable
        public func end(_ format: StaticString, _ arguments: CVarArg...) {
            os_signpost(.end, log: log, name: name, signpostID: id, format, arguments)
        }
        
        @inlinable
        public func event(name: StaticString = #function) {
            os_signpost(.event, log: log, name: name, signpostID: id)
        }
    }
    
    @usableFromInline
    let log: OSLog
    
    @inlinable
    public init(category: String) {
        guard let subsystem = Bundle.main.bundleIdentifier else {
            preconditionFailure("Could not get bundle identifier from the main bundle")
        }
        
        log = OSLog(subsystem: subsystem, category: category)
    }
    
    @inlinable
    public func begin(name: StaticString = #function) -> Tracing {
        return Tracing(log: log, name: name)
    }
    
    @inlinable
    public func begin(name: StaticString = #function, _ format: StaticString, _ arguments: CVarArg...) -> Tracing {
        return Tracing(log: log, name: name, format: format, arguments: arguments)
    }
    
    @inlinable
    public func debug(_ format: StaticString, _ arguments: CVarArg...) {
        os_log(format, log: log, type: .debug, arguments)
    }
    
    @inlinable
    public func event(name: StaticString = #function) {
        os_signpost(.event, log: log, name: name)
    }
}
