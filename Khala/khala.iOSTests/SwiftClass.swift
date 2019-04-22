//
//  SwiftClass.swift
//  khala.swift.tests
//
//  Created by linhey on 2018/11/23.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import UIKit
import Khala

@objc(SwiftClass) @objcMembers
class SwiftClass: NSObject {
  
  // MARK: - 测试返回值类型
  var string = "test.test.ios"
  var double: Double = 66.66
  var int: Int = 55
  var float: Float = 44.44
  var bool: Bool = true
  var array = ["value1", "value2", "value3", 5431, 54.45] as [AnyHashable]
  var dict = ["value" : 46, "style" : 1, "marketIid": "model.marketIid"] as [String : AnyHashable]
  
}


// MARK: - 测试函数参数类型
extension SwiftClass {
  
  func functionForDict(_ info: KhalaInfo) -> Bool {
    print(info)
    return true
  }
  
  
  func functionForBlock(_ closure: KhalaClosure) -> Bool {
    closure(["name": #function])
    return true
  }
  
}


extension SwiftClass {
  //  - key : "definition5:success:failure:other:"
  //  - key : "definition3:success:"
  //  - key : "definition2:"
  //  - key : "definition1"
  //  - key : "definition4:success:failure:"
  
  func notfound(_ url: URL, info: KhalaInfo) {
    
  }
  
  func definition1() {
    print(#function)
  }
  
  func definition2(_ info: KhalaInfo? = nil) {
    print(#function)
  }
  
  func definition3(_ info: KhalaInfo, success: KhalaClosure? = nil) {
    do {
      var info = info
      info["type"] = "success"
      success?(info)
    }
  }
  
  func definition4(_ info: KhalaInfo, success: KhalaClosure, failure: KhalaClosure) {
    do {
      var info = info
      info["type"] = "success"
      success(info)
    }
    do {
      var info = info
      info["type"] = "failure"
      failure(info)
    }
  }
  
  func definition5(_ info: [String: Any], success: KhalaClosure, failure: KhalaClosure, other: KhalaClosure) {
    do {
      var info = info
      info["type"] = "success"
      success(info)
    }
    do {
      var info = info
      info["type"] = "failure"
      failure(info)
    }
    do {
      var info = info
      info["type"] = "other"
      other(info)
    }
  }
  
  
}


