//
//  ViewController.swift
//  khala.iOS
//
//  Created by linhey on 2018/12/12.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import UIKit
import Khala

public
extension KhalaStore {
  
 class func aModule_vc() -> UIViewController {
    return Khala(str: "kl://AModule/vc")!.viewController!
  }
  
 class func bModule_vc() -> UIViewController {
    return Khala(str: "kl://BModule/vc")!.viewController!
  }
  
}
