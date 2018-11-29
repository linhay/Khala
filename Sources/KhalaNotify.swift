//
//  KhalaNotify.swift
//  BLFoundation
//
//  Created by linhey on 2018/11/28.
//

import Foundation

public class KhalaNotify: NSObject {
  
  let urlValue: URLValue
  var rewrite = Rewrite.default
  
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = rewrite.separate((url,params))
    super.init()
  }
  
  public init?(url: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: url) else { return nil }
    urlValue = rewrite.separate((tempURL,params))
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
        var components = URLComponents(url: urlValue.url, resolvingAgainstBaseURL: true)
        guard let componentsHost = components?.host else { return nil }
        components?.path = componentsHost
        components?.host = host.description
        guard let url = components?.url else { return nil }
        return (url: url, params: urlValue.params)
      }
      .compactMap { Khala(url: $0.url, params: $0.params).call() }
  }
  
}
