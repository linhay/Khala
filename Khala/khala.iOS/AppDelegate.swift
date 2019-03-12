//
//  AppDelegate.swift
//  khala.iOS
//
//  Created by linhey on 2018/12/12.
//  Copyright © 2018 www.linhey.com. All rights reserved.
//

import UIKit
import Khala

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    Khala.appDelegate.window = window
    _ = Khala.appDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
    window?.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Khala.appDelegate.applicationWillResignActive(application)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    Khala.appDelegate.applicationDidEnterBackground(application)
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    Khala.appDelegate.applicationWillEnterForeground(application)
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    Khala.appDelegate.applicationDidBecomeActive(application)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    Khala.appDelegate.applicationWillTerminate(application)
  }


}

