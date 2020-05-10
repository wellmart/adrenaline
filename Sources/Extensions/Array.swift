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

public extension Array {
    @inlinable
    init(reserveCapacity: Int) {
        self.init()
        self.reserveCapacity(reserveCapacity)
    }
    
    @inlinable
    func concurrentForEach(threads: Int = 4, execute work: (Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count, threads: threads) {
            work(self[$0])
        }
    }
    
    @inlinable
    func concurrentMap<T>(threads: Int = 4, transform: (Element) -> T) -> [T] {
        return Array<T>(unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard let baseAddress = buffer.baseAddress else {
                return
            }
            
            DispatchQueue.concurrentPerform(iterations: count, threads: threads) {
                (baseAddress + $0).initialize(to: transform(self[$0]))
            }
            
            initializedCount = count
        }
    }
    
    @inlinable
    func forEachGrouped<T: Equatable>(by keyPath: KeyPath<Element, T>, _ keyBody: (T) -> Void, _ body: (Element) -> Void) {
        var key: T? = nil
        
        for element in self {
            let itemKey = element[keyPath: keyPath]
            
            if itemKey != key {
                keyBody(itemKey)
                key = itemKey
            }
            
            body(element)
        }
    }
}

public extension Array where Element: Equatable {
    @inlinable
    mutating func remove(element: Element) {
        guard let index = firstIndex(of: element) else {
            return
        }
        
        remove(at: index)
    }
}
