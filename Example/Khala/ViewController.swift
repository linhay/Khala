//
//  ViewController.swift
//  Khala
//
//  Created by linhay on 10/23/2018.
//  Copyright (c) 2018 linhay. All rights reserved.
//

import Cocoa
import Khala

class ViewController: NSViewController {

  @IBAction func tapEvent(_ sender: NSClickGestureRecognizer) {
  let insten = PseudoClass(name: "TestClass")
    let taget = TestClass()
    insten?.instance = taget
    insten?.send(method: insten!.methodLists["setDouble:"]!, args: [0.6])
    print(taget.double)
  }
  
}

