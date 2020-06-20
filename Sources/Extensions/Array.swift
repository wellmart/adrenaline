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
import Accelerate

public extension Array {
    @inlinable
    init(reserveCapacity: Int) {
        self.init()
        self.reserveCapacity(reserveCapacity)
    }
    
    @inlinable
    subscript(optional index: Index) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
    
    @inlinable
    func count(where predicate: (Element) -> Bool) -> Int {
        var count = 0
        
        for element in self where predicate(element) {
            count += 1
        }
        
        return count
    }
    
    @inlinable
    func firstOf<T>(_ type: T.Type) -> T? {
        return first { $0 is T } as? T
    }
    
    @inlinable
    func forEach<T: Comparable>(groupedBy keyPath: KeyPath<Element, T>, _ keyBody: (T) -> Void, _ body: (Element) -> Void) {
        let elements = sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        var lastKey: T? = nil
        
        for element in elements {
            let key = element[keyPath: keyPath]
            
            if lastKey != key {
                keyBody(key)
                lastKey = key
            }
            
            body(element)
        }
    }
}

public extension Array where Element == Double {
    @inlinable
    func maximum() -> Double {
        var value: Double = 0
        vDSP_maxvD(self, 1, &value, vDSP_Length(count))
        
        return value
    }
    
    @inlinable
    func minimum() -> Double {
        var value: Double = 0
        vDSP_minvD(self, 1, &value, vDSP_Length(count))
        
        return value
    }
    
    @inlinable
    func sum() -> Double {
        var value: Double = 0
        vDSP_sveD(self, 1, &value, vDSP_Length(count))
        
        return value
    }
}

public extension Array where Element: Equatable {
    @inlinable
    mutating func remove(_ element: Element) {
        guard let index = firstIndex(of: element) else {
            return
        }
        
        remove(at: index)
    }
}
