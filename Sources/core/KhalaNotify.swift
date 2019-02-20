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

/// You can use this class to notify functions at the `PseudoClass.cache`.
@objcMembers
public class KhalaNotify: NSObject {
  
  let urlValue: KhalaNode
    
  /// init
  ///
  /// - Parameters:
  ///   - url: URL
  ///   - params: Use it when you need to pass NSObject/UIImage, etc.
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = Rewrite.separate(KhalaNodeValue(url: url,params: params))
    super.init()
  }
  
  /// init
  ///
  /// - Parameters:
  ///   - str: String type URL
  ///   - params: Use it when you need to pass NSObject/UIImage, etc.
  public init?(str: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: str) else { return nil }
    urlValue = Rewrite.separate(KhalaNodeValue(url: tempURL,params: params))
    super.init()
  }
  
}


extension KhalaNotify {
  
  /// Call notification
  ///
  /// - Returns: Return value array for all routing functions
  @discardableResult
  public func call() -> [Any] {
    guard let method = urlValue.url.host else { return [] }
    return KhalaClass.cache
      .compactMap { (pseudo) -> String? in
        guard let list = pseudo.value.findMethod(name: method) else { return nil }
        return list.isEmpty ? nil : pseudo.key
      }
      .compactMap { (host) -> KhalaNode? in
        guard let scheme = urlValue.url.scheme, let path = urlValue.url.host else { return nil }
        let str = scheme + "://" + host + "/" + path
        guard let url = URL(string: str) else { return nil }
        return KhalaNodeValue(url: url, params: urlValue.params)
      }
      .compactMap { Khala(url: $0.url, params: $0.params).call() }
  }
  
}
