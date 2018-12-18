//
//  ViewController.swift
//  khala.iOS
//
//  Created by linhey on 2018/12/12.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import UIKit
import Khala

@objc(BModule) @objcMembers
class BModule: NSObject {
  
  func vc() -> UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.red
    return vc
  }
  
  func doSomething(_ info: [String: Any]) -> String {
    return description
  }
  
}



