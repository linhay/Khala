//
//  Rewrite.swift
//  BLFoundation
//
//  Created by linhey on 2018/11/19.
//
import Foundation

@objcMembers
public class RewriteFilter: NSObject {
  
  let closure: (_ value: URLValue) -> URLValue
  
  public init(_ closure: @escaping (_ value: URLValue) -> URLValue) {
    self.closure = closure
    super.init()
  }
  
}

@objcMembers
public class Rewrite: NSObject {
  
  public static let shared = Rewrite()
  
  func separate(_ value: URLValue) -> URLValue {
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
    
    return redirect(value)
  }
  
  public var filters = [RewriteFilter]()
    
  func redirect(_ value: URLValue) -> URLValue {
    return filters.reduce(value) { (result, filter) -> URLValue in
      return filter.closure(result)
    }
  }
  
}
