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
class AModule: NSObject,UIApplicationDelegate {
  
  func vc() -> UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.red
    return vc
  }
  
  func doSomething(_ info: KhalaInfo) -> String {
    return description
  }
  
  func server(_ info: KhalaInfo) -> Int {
    return info["value"] as? Int ?? 0
  }
  
  func server2(_ info: KhalaInfo) -> Int {
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
  
  func forClosures(_ info: KhalaInfo, success: KhalaClosure, failure: KhalaClosure) {
    success(["success": #function])
    failure(["failure": #function])
  }

}



