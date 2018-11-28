//
//  Rewrite.swift
//  BLFoundation
//
//  Created by linhey on 2018/11/19.
//
import Foundation

class RewriteFilter: NSObject {
  
  let closure: (_ value: URLValue) -> URLValue
  
  init(_ closure: @escaping (_ value: URLValue) -> URLValue) {
    self.closure = closure
    super.init()
  }
  
}

class Rewrite: NSObject {
  
  public var filters = [RewriteFilter]()
  
  public func redirect(_ value: URLValue) -> URLValue {
    return filters.reduce(value) { (result, filter) -> URLValue in
      return filter.closure(result)
    }
  }
  
}
