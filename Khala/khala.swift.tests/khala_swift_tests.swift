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
    let value = Khala(url: "kl://SwiftClass/double?test=666")?.call()
    print(value)
  }
  

}
