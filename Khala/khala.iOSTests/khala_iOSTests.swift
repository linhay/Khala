//
//  khala_swift_tests.swift
//  khala.swift.tests
//
//  Created by linhey on 2018/11/23.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import XCTest
import Khala

class khala_swift_tests: XCTestCase {
  
  /// 测试返回值类型
  func testGetIvars() {
    let target = SwiftClass()
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/string")?.call() as? String
      XCTAssert(value == target.string, "\(String(describing: value))")
    }
    
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/double")?.call() as? Double
      XCTAssert(value == target.double, "\(String(describing: value))")
    }

    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/float")?.call() as? Float
      XCTAssert(value == target.float, "\(String(describing: value))")
    }
    
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/bool")?.call() as? Bool
      XCTAssert(value == target.bool, "\(String(describing: value))")
    }
    
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/dict")?.call() as? [String: AnyHashable]
      XCTAssert(value == target.dict, "\(value!.description)")
    }
    
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/array")?.call() as? [AnyHashable]
      XCTAssert(value == target.array, "\(value!.description)")
    }
  }
  
  /// 测试参数类型
  func testParam() {
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/functionForDict?name=\(#function)")?.call() as? Bool
      XCTAssert(value!)
    }
    
    autoreleasepool {
      let value = Khala(str: "kl://SwiftClass/functionForBlock")?.call(block: { (item) in
        print(item)
      }) as? Bool
      XCTAssert(value!)
    }
  }
  
  func testCallFuncs() {
    Khala.isEnabledAssert = false
    let expectation = XCTestExpectation(description: "Download apple.com home page")
    
    let success: KhalaClosure = { (item) in
      print(item)
      expectation.fulfill()
    }
    
    let value = Khala(str: "kl://SwiftClass/definition3?test=666")?.call(blocks: [success])
    wait(for: [expectation], timeout: 10.0)
  }
  
  func testNotifys() {
    Khala.isEnabledAssert = false
    Khala(str: "kl://SwiftClass/double?test=666")?.call()
    guard let value = KhalaNotify(str: "kl://double?test=666")?.call() as? [Double] else {
      XCTAssertFalse(true)
      return
    }
    XCTAssert(value == [66.66])
  }
  
  
  func testRegist() {
    Khala.isEnabledAssert = false
    Khala.registWithKhalaProtocol()
    guard let value = KhalaNotify(str: "kl://double?test=666")?.call() as? [Double] else {
      XCTAssertFalse(true)
      return
    }
    XCTAssert(value == [66.66])
  }
  
}
