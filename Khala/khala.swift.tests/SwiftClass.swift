//
//  SwiftClass.swift
//  khala.swift.tests
//
//  Created by linhey on 2018/11/23.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import Cocoa
import Khala

@objc(SwiftClass)
class SwiftClass: NSObject {
  
  // "double"
  // "setDouble:"
  @objc var double = 66.66
  
//  - key : "definition5:success:failure:other:"
//  - key : "definition3:success:"
//  - key : "definition2:"
//  - key : "definition1"
//  - key : "definition4:success:failure:"
  
  @objc func notfound(_ url: URL, info: [String: Any]) {
    
  }

  @objc func definition1() {
    print(#function)
  }
  
  @objc func definition2(_ info: [String: Any]? = nil) {
    print(#function)
  }
  
  @objc func definition3(_ info: [String: Any], success: KhalaClosure? = nil) {
    do {
      var info = info
      info["type"] = "success"
      success?(info)
    }
  }
  
  @objc func definition4(_ info: [String: Any], success: KhalaClosure, failure: KhalaClosure) {
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
  
  @objc func definition5(_ info: [String: Any], success: KhalaClosure, failure: KhalaClosure, other: KhalaClosure) {
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
