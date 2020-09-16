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

@propertyWrapper
public struct UserDefaultCodable<T: Codable> {
    public typealias DefaultBlock = () -> T
    
    private let key: String
    private let defaultBlock: DefaultBlock
    
    public init(_ key: String, defaultValue defaultBlock: @autoclosure @escaping DefaultBlock) {
        self.key = key
        self.defaultBlock = defaultBlock
    }
    
    public var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.data(forKey: key), let value = try? JSONDecoder().decode(T.self, from: data) {
                return value
            }
            
            return defaultBlock()
        }
        set {
            UserDefaults.standard.setValue(try? JSONEncoder().encode(newValue), forKey: key)
        }
    }
}
