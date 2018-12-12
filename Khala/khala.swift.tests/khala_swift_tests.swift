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
  
  
  func testCallIvars() {
    Khala.isEnabledAssert = false
    let value = Khala(str: "kl://SwiftClass/double?test=666")?.call()
    print(value)
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
