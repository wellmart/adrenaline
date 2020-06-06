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
    func first<T>(of: T.Type) -> T? {
        return first { $0 is T } as? T
    }
    
    @inlinable
    func forEachGrouped<T: Comparable>(by keyPath: KeyPath<Element, T>, _ keyBody: (T) -> Void, _ body: (Element) -> Void) {
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
    var maximum: Double {
        var maximum: Double = 0
        vDSP_maxvD(self, 1, &maximum, vDSP_Length(count))
        
        return maximum
    }
    
    @inlinable
    var minimum: Double {
        var minimum: Double = 0
        vDSP_minvD(self, 1, &minimum, vDSP_Length(count))
        
        return minimum
    }
    
    @inlinable
    var sum: Double {
        var sum: Double = 0
        vDSP_sveD(self, 1, &sum, vDSP_Length(count))
        
        return sum
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
