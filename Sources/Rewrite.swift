//
//  Rewrite.swift
//  BLFoundation
//
//  Created by linhey on 2018/11/19.
//
import Foundation

public class RewriteFilter: NSObject {
  
  let closure: (_ value: URLValue) -> URLValue
  
  public init(_ closure: @escaping (_ value: URLValue) -> URLValue) {
    self.closure = closure
    super.init()
  }
  
}

public class Rewrite: NSObject {
  
  static let `default` = Rewrite()
  
  public func separate(_ value: URLValue) -> URLValue {
    var value = value
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
  
  public var filters = [RewriteFilter]()
  
  public func redirect(_ value: URLValue) -> URLValue {
    return filters.reduce(value) { (result, filter) -> URLValue in
      return filter.closure(result)
    }
  }
  
}
