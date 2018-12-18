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

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let vc = Khala(str: "kl://AModule/vc?style=0")?.viewController else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }

}

