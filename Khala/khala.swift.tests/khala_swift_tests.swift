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
    let value = Khala(url: "kl://SwiftClass/double?test=666")?.call()
    print(value)
  }
  
  func testCallFuncs() {
    Khala.isEnabledAssert = false
    let expectation = XCTestExpectation(description: "Download apple.com home page")

    let success: KhalaClosure = { (item) in
      print(item)
      expectation.fulfill()
    }
    
    let value = Khala(url: "kl://SwiftClass/definition3?test=666")?.call(blocks: success)

    wait(for: [expectation], timeout: 10.0)
    
  }
  

}
