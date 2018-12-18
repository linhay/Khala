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

/** 通知类 - 可同时调用 `PseudoClass.cache` 中所有匹配的路由函数.
*/
@objcMembers
public class KhalaNotify: NSObject {
  
  let urlValue: KhalaURLValue
    
  /// 初始化函数
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: 需要传递参数
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = Rewrite.separate(URLValue(url: url,params: params))
    super.init()
  }
  
  /// 初始化函数
  ///
  /// - Parameters:
  ///   - str: url string 类型
  ///   - params: 需要传递参数
  public init?(str: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: str) else { return nil }
    urlValue = Rewrite.separate(URLValue(url: tempURL,params: params))
    super.init()
  }
  
}


extension KhalaNotify {
  
  /// 通知l调用
  ///
  /// - Returns: 所有路由函数的返回值集合
  @discardableResult
  public func call() -> [Any] {
    guard let method = urlValue.url.host else { return [] }
    return PseudoClass.cache
      .compactMap { (pseudo) -> String? in
        guard let list = pseudo.value.findMethod(name: method) else { return nil }
        return list.isEmpty ? nil : pseudo.key
      }
      .compactMap { (host) -> URLValue? in
        guard let scheme = urlValue.url.scheme, let path = urlValue.url.host else { return nil }
        let str = scheme + "://" + host + "/" + path
        guard let url = URL(string: str) else { return nil }
        return URLValue(url: url, params: urlValue.params)
      }
      .compactMap { Khala(url: $0.url, params: $0.params).call() }
  }
  
}
