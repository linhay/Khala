//
//  BModuleVC.swift
//  AModule
//
//  Created by linhey on 2018/12/19.
//

import UIKit
import Khala
import KhalaStore

class BModuleVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    
    guard #available(iOS 9.0, *) else { return }
    
    let stackView = UIStackView(frame: view.frame)
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    view.addSubview(stackView)
    
    autoreleasepool {
      let btn = UIButton()
      btn.setTitle("jump to AModule.vc", for: UIControl.State.normal)
      btn.addTarget(self, action: #selector(jumpToAModuleVC), for: UIControl.Event.touchUpInside)
      stackView.addArrangedSubview(btn)
    }
    
  }
  
  
  @objc func jumpToAModuleVC() {
    let vc = KhalaStore.aModule_vc()
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
