//
//  Khala
//
//  Copyright (c) 2018 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation

/// When you want to customize the Rewrite module, you need to inherit the protocol.
@objc
public protocol KhalaRewrite {
  var filters: [KhalaRewriteFilter] { get set }
  func redirect(_ value: KhalaNode) -> KhalaNode
  static func separate(_ value: KhalaNode) -> KhalaNode
  func add(filter: KhalaRewriteFilter)
  func add(filters: [KhalaRewriteFilter])
}

/// Rewrite 规则单元
@objcMembers
public class KhalaRewriteFilter: NSObject {
  
  let closure: (_ value: KhalaNode) -> KhalaNode
  
  /// 初始化
  ///
  /// - Parameter closure: 规则
  public init(_ closure: @escaping (_ value: KhalaNode) -> KhalaNode) {
    self.closure = closure
    super.init()
  }
  
}

@objcMembers
class Rewrite: NSObject, KhalaRewrite {
  
  func add(filter: KhalaRewriteFilter) {
    Rewrite.shared.filters.append(filter)
  }
  
  func add(filters: [KhalaRewriteFilter]) {
    Rewrite.shared.filters += filters
  }
  
  
  static let shared = Rewrite()
  var filters = [KhalaRewriteFilter]()

  class func separate(_ value: KhalaNode) -> KhalaNode {
    let value = value
    var components = URLComponents(url: value.url, resolvingAgainstBaseURL: true)
    components?.queryItems?.forEach({ (item) in
      if value.params[item.name] == nil {
        value.params[item.name] = item.value
      }
    })
    components?.queryItems?.removeAll()
    
    guard let redirectURL = components?.url else {
      return value
    }
    value.url = redirectURL
    
    return value
  }
  
  
  func redirect(_ value: KhalaNode) -> KhalaNode {
    return filters.reduce(value) { (result, filter) -> KhalaNode in
      return filter.closure(result)
    }
  }
  
}
