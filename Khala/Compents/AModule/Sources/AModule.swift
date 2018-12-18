//
//  ViewController.swift
//  khala.iOS
//
//  Created by linhey on 2018/12/12.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import UIKit
import Khala

@objc(AModule) @objcMembers
class AModule: NSObject {
  
  func vc() -> UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.red
    return vc
  }
  
  func doSomething(_ info: [String: Any]) -> String {
    return description
  }
  
  func server(_ info: [String: Any]) -> Int {
    return info["value"] as? Int ?? 0
  }
  
  func server2(_ info: [String: Any]) -> Int {
    guard let value = info["value"] as? String, let res = Int(value) else { return 0 }
    return res
  }
  
  func forClosure(_ closure: KhalaClosure) {
    closure(["value": #function])
  }
  
  func forClosures(_ success: KhalaClosure, failure: KhalaClosure) {
    success(["success": #function])
    failure(["failure": #function])
  }

}



