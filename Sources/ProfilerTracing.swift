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

public protocol ProfilerTracingProtocol {
    func end()
    
    func end(_ message: String)
    
    func event(name: StaticString)
}

@frozen
@available(macOS 10.14, iOS 12, tvOS 12, watchOS 5, *)
public struct ProfilerTracing: ProfilerTracingProtocol {
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
    init(log: OSLog, name: StaticString, message: String) {
        self.log = log
        self.name = name
        self.id = OSSignpostID(log: log)
        
        os_signpost(.begin, log: log, name: name, signpostID: id, "%@", message)
    }
    
    @inlinable
    public func end() {
        os_signpost(.end, log: log, name: name, signpostID: id)
    }
    
    @inlinable
    public func end(_ message: String) {
        os_signpost(.end, log: log, name: name, signpostID: id, "%@", message)
    }
    
    @inlinable
    public func event(name: StaticString) {
        os_signpost(.event, log: log, name: name, signpostID: id)
    }
}
