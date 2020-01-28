# Adrenaline

[![Build Status](https://travis-ci.org/wellmart/adrenaline.svg?branch=master)](https://travis-ci.org/wellmart/adrenaline)
[![Swift 5](https://img.shields.io/badge/swift-5-blue.svg)](https://developer.apple.com/swift/)
![Version](https://img.shields.io/badge/version-0.1.0-blue)
[![Software License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Swift Package Manager Compatible](https://img.shields.io/badge/swift%20package%20manager-compatible-blue.svg)](https://github.com/apple/swift-package-manager)

A framework with lot of extensions to improve the development, more adrenaline on life.

## Requirements

Swift 5 and beyond.

## Usage

```swift
import UIKit
import Adrenaline

func main() {
    let items = [String](reserveCapacity: 100)
    
    if let item = items[safe: 50] {
        NSLog(item)
    }
    
    NSLog(666.string(paddingLeft: 7))
    
    let view = UIView().apply {
        $0.backgroundColor = .red
    }
}
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
