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
    // AModule 与 BModule 移除缓存实例
    Khala(str: "kl://AModule")?.unregister()
    Khala(str: "kl://BModule")?.unregister()
    
    // AModule 与 BModule 实例化,并缓存
    Khala(str: "kl://AModule")?.register()
    Khala(str: "kl://BModule")?.register()
    
    // 通知
    let value = KhalaNotify(str: "kl://doSomething")?.call()
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
  
  @IBAction func event4(_ sender: Any) {
    let filter = RewriteFilter {
      if $0.url.host == "AModule" {
        var urlComponents = URLComponents(url: $0.url, resolvingAgainstBaseURL: true)!
        urlComponents.host = "BModule"
        $0.url = urlComponents.url!
      }
      return $0
    }
    Khala.rewrite.filters.append(filter)
    
    let value = Khala(str: "kl://AModule/doSomething")?.call()
    print(value ?? "nil")
  }
  
  
  @IBAction func event5(_ sender: Any) {
    guard let vc = Khala(str: "kl://BModule/vc?style=0")?.viewController else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

