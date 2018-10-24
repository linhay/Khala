//
//  TestSuperClass.swift
//  Khala_Example
//
//  Created by linhey on 2018/10/23.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa

@objcMembers
class TestSuperClass: NSObject {
  
  var string = ""
  var int = 88
  var double = 66.66{
    didSet{
      print(double)
    }
  }
  var bool = true
  var null: Any? = nil
  var dict = ["key1": "value2",
              "key2": "value2"]
  var array = ["element1","element2"]
  
  var block: ((_ info: [String: Any]) -> Void)?
  
  func testName() {
    print(#function)
  }
  
 static func staticTestName() {
    print(#function)
  }
  
}
