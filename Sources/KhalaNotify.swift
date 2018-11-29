//
//  KhalaNotify.swift
//  BLFoundation
//
//  Created by linhey on 2018/11/28.
//

import Foundation


@objcMembers
public class KhalaNotify: NSObject {
  let urlValue: URLValue
  
  public var rewrite = Rewrite.shared
  
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = rewrite.separate(URLValue(url: url,params: params))
    super.init()
  }
  
  public init?(str: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: str) else { return nil }
    urlValue = rewrite.separate(URLValue(url: tempURL,params: params))
    super.init()
  }
  
}


extension KhalaNotify {
  
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
