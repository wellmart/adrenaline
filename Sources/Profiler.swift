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

public protocol ProfilerProtocol {
    func begin(name: StaticString) -> TracingProtocol
    
    func begin(name: StaticString, _ message: String) -> TracingProtocol
    
    func debug(_ message: String)
    
    func event(name: StaticString)
    
    func info(_ message: String)
}

extension ProfilerProtocol {
    @inlinable
    public static func create(category: String) -> ProfilerProtocol? {
        if #available(macOS 10.14, iOS 12, tvOS 12, watchOS 5, *) {
            return Profiler(category: category)
        }
        
        return nil
    }
}

@available(macOS 10.14, iOS 12, tvOS 12, watchOS 5, *)
public struct Profiler: ProfilerProtocol {
    @usableFromInline
    let log: OSLog
    
    @inlinable
    init(category: String) {
        guard let subsystem = Bundle.main.bundleIdentifier else {
            preconditionFailure("Could not get bundle identifier from the main bundle")
        }
        
        log = OSLog(subsystem: subsystem, category: category)
    }
    
    @inlinable
    public func begin(name: StaticString) -> TracingProtocol {
        return Tracing(log: log, name: name)
    }
    
    @inlinable
    public func begin(name: StaticString, _ message: String) -> TracingProtocol {
        return Tracing(log: log, name: name, message: message)
    }
    
    @inlinable
    public func debug(_ message: String) {
        os_log(.debug, log: log, "%@", message)
    }
    
    @inlinable
    public func event(name: StaticString) {
        os_signpost(.event, log: log, name: name)
    }
    
    @inlinable
    public func info(_ message: String) {
        os_log(.info, log: log, "%@", message)
    }
}
