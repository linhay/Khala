//
//  ViewController.swift
//  Khala
//
//  Created by linhay on 10/23/2018.
//  Copyright (c) 2018 linhay. All rights reserved.
//

import Cocoa
import Khala
import BLFoundation


class ViewController: NSViewController {
  
  
  @IBAction func tapEvent(_ sender: NSClickGestureRecognizer) {
    Khala.isEnabledAssert = false
    let value = Khala(url: "kl://SwiftClass/double?test=666")?.call()
    print(value)
  }
  
  //  func testIvars() {
  //    let insten = PseudoClass(name: "TestClass")!
  //    let taget = TestSuperClass()
  //    insten.instance = taget
  //
  //    insten.send(method: insten.methodLists["setDouble:"]!, args: 0.6)
  //    print(insten.send(method: insten.methodLists["double"]!)!)
  //
  //    insten.send(method: insten.methodLists["setInt:"]!, args: 999)
  //    print(insten.send(method: insten.methodLists["int"]!)!)
  //
  //    insten.send(method: insten.methodLists["setString:"]!, args: NSString(string: "test-string"))
  //    print(insten.send(method: insten.methodLists["string"]!)!)
  //
  //    insten.send(method: insten.methodLists["setBool:"]!, args: true)
  //    print(insten.send(method: insten.methodLists["bool"]!)!)
  //    //    给 id 类型 必须继承自 NSObject(暂时如此)
  //    //    insten.send(method: insten.methodLists["setNull:"]!, args: 12)
  //    //    print(insten.send(method: insten.methodLists["null"]!)!)
  //
  //    insten.send(method: insten.methodLists["setNull:"]!, args: "1235")
  //    print(insten.send(method: insten.methodLists["null"]!)!)
  //
  //    insten.send(method: insten.methodLists["setDict:"]!, args: ["222": "666"])
  //    print(insten.send(method: insten.methodLists["dict"]!) as! [String: Any])
  //
  //    insten.send(method: insten.methodLists["setArray:"]!, args: ["777", "888"])
  //    print(insten.send(method: insten.methodLists["array"]!)! as! [Any])
  //
  //    let block: (@convention(block) (_ : [String: Any]) -> Void) = { (dict: [String: Any]) in
  //      print(dict)
  //    }
  //
  //    insten.send(method: insten.methodLists["setBlock:"]!, args: block)
  //  }
  
}

