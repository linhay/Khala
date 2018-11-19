//
//  TestSuperClass.swift
//  Khala_Example
//
//  Created by linhey on 2018/10/23.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa
import Khala

@objcMembers
class TestSuperClass: NSObject {
  
  var int = 88
  var string: String = ""
  var double = 66.66
  var bool = true
  var null: Any? = nil
  var dict = ["key1": "value2", "key2": "value2"]
  var array = ["element1","element2"]
  var block: (@convention(block) (_ : [String: Any]) -> Void)? = nil {
    didSet{
      block?(["block": "666"])
    }
  }
  
  func testName() {
    print(#function)
  }
  
 static func staticTestName() {
    print(#function)
  }
  
  override func doesNotRecognizeSelector(_ aSelector: Selector!) {
    
  }
  
}
