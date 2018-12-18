//
//  ViewController.swift
//  khala.iOS
//
//  Created by linhey on 2018/12/12.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import UIKit
import Khala

class ViewController: UIViewController {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let vc = Khala(str: "kl://AModule/vc?style=0")?.viewController else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func event1(_ sender: UIButton) {
    autoreleasepool {
      let value = Khala(str: "kl://AModule/server", params: ["value": 46])?.call() as? Int
      print(value ?? "nil")
    }
    
    autoreleasepool {
      let value = Khala(str: "kl://AModule/server2?value=64")?.call() as? Int
      print(value ?? "nil")
    }
  }
  
  @IBAction func event2(_ sender: Any) {
    // AModule 与 BModule 实例化,并缓存
    _ = Khala(str: "kl://AModule/vc")?.viewController
    _ = Khala(str: "kl://BModule/vc")?.viewController
    
    // 通知
    let value = KhalaNotify(str: "kl://doSomething?value=888")?.call()
    print(value ?? "")
  }
  
  
  @IBAction func event(_ sender: Any) {
    
    Khala(str: "kf://AModule/forClosure")?.call(block: { (item) in
      print("forClosure:", item)
    })
    
    Khala(str: "kf://AModule/forClosures")?.call(blocks: [{ (item) in
      print("forClosures block1:", item)
      },{ (item) in
        print("forClosure block2:", item)
      }])
    
  }
  
}

