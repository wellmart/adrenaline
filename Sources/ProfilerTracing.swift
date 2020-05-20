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

public protocol ProfilerTracingProtocol {
    func end()
    
    func end(_ message: String)
    
    func event(name: StaticString)
}

@available(macOS 10.14, iOS 12, tvOS 12, watchOS 5, *)
public struct ProfilerTracing: ProfilerTracingProtocol {
    private let log: OSLog
    private let name: StaticString
    private let signpostID: OSSignpostID

    init(log: OSLog, name: StaticString) {
        let signpostID = OSSignpostID(log: log)
        
        self.log = log
        self.name = name
        self.signpostID = signpostID
        
        os_signpost(.begin, log: log, name: name, signpostID: signpostID)
    }

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

    public func end() {
        os_signpost(.end, log: log, name: name, signpostID: signpostID)
    }

    public func end(_ message: String) {
        os_signpost(.end, log: log, name: name, signpostID: signpostID, "%@", message)
    }

    public func event(name: StaticString) {
        os_signpost(.event, log: log, name: name, signpostID: signpostID)
    }
}
