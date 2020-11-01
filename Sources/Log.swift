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

import _SwiftOSOverlayShims
import os
import Foundation

public struct Log {
    @usableFromInline
    let log: OSLog
    
    @inlinable
    public init(category: String) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            preconditionFailure("Can't get bundle identifier")
        }
        
        log = OSLog(subsystem: bundleIdentifier, category: category)
    }
    
    @inlinable
    public func debug(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, _ args: CVarArg...) {
        #if DEBUG
        log(type: .debug, message: message, dso: dso, args: args)
        #endif
    }
    
    @inlinable
    public func error(_ error: Error, dso: UnsafeRawPointer? = #dsohandle) {
        log(type: .error, message: "🔶 ERROR: %@", dso: dso, args: [(error as CustomStringConvertible).description])
    }
    
    @usableFromInline
    func log(type: OSLogType, message: StaticString, dso: UnsafeRawPointer?, args: [CVarArg]) {
        let ra = _swift_os_log_return_address()
        
        message.withUTF8Buffer { buffer in
            buffer.baseAddress.unsafelyUnwrapped.withMemoryRebound(to: CChar.self, capacity: buffer.count) { str in
                withVaList(args) { valist in
                    _swift_os_log(dso, ra, log, type, str, valist)
                }
            }
        }
    }
}
