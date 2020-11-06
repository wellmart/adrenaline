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

public extension String {
    @inlinable
    static var empty: String {
        return String()
    }
    
    @inlinable
    init(reserveCapacity: Int) {
        self.init()
        self.reserveCapacity(reserveCapacity)
    }
    
    func camelCaseToSnakeCase(separator: String = "_") -> String {
        let uppercaseLetters = CharacterSet.uppercaseLetters
        var result = String(reserveCapacity: count)
        
        for scalar in unicodeScalars {
            if uppercaseLetters.contains(scalar) && !result.isEmpty {
                result.append(separator)
            }
            
            result.append(Character(scalar))
        }
        
        return result.lowercased()
    }
    
    @inlinable
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    @inlinable
    func trim() -> String {
        return trimmingCharacters(in: .whitespaces)
    }
}
