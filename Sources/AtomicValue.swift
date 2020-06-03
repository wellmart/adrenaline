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

@available(macOS 10.12, iOS 10, tvOS 12, watchOS 3, *)
public final class AtomicValue<T> {
    public private(set) var value: T
    private lazy var lock = os_unfair_lock()
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func mutate(_ transform: (inout T) -> ()) {
        defer {
            os_unfair_lock_unlock(&lock)
        }
        
        os_unfair_lock_lock(&lock)
        transform(&value)
    }
}

@available(macOS 10.12, iOS 10, tvOS 12, watchOS 3, *)
public extension AtomicValue where T: SignedInteger {
    @inlinable
    static var zero: Self {
        return Self(0)
    }
}

@available(macOS 10.12, iOS 10, tvOS 12, watchOS 3, *)
public extension AtomicValue where T: FloatingPoint {
    @inlinable
    static var zero: Self {
        return Self(0)
    }
}
