//
//  AModuleApplicationDelegate.swift
//  AModule
//
//  Created by linhey on 2019/3/11.
//

import Foundation

class AModuleApplicationDelegate: NSObject, UIApplicationDelegate {
  
   func applicationDidFinishLaunching(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationSignificantTimeChange(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    print(String(describing: self) + ": " + #function)
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  @available(iOS 9.0, *)
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
    print(String(describing: self) + ": " + #function)
  }
  
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask  {
    print(String(describing: self) + ": " + #function)
    return UIInterfaceOrientationMask.all
  }
  
  func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
    print(String(describing: self) + ": " + #function)
    return nil
  }
  
  func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool  {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
    print(String(describing: self) + ": " + #function)
  }
  
  func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
    print(String(describing: self) + ": " + #function)
  }

  open func setStatusBarOrientation(_ interfaceOrientation: UIInterfaceOrientation, animated: Bool) {
    print(String(describing: self) + ": " + #function)
  }
  
  open func setStatusBarStyle(_ statusBarStyle: UIStatusBarStyle, animated: Bool) {
    print(String(describing: self) + ": " + #function)
  }
  
  open func setStatusBarHidden(_ hidden: Bool, with animation: UIStatusBarAnimation) {
    print(String(describing: self) + ": " + #function)
  }
  
  open func setKeepAliveTimeout(_ timeout: TimeInterval, handler keepAliveHandler: (() -> Void)? = nil) -> Bool {
    print(String(describing: self) + ": " + #function)
    return true
  }
  
  open func clearKeepAliveTimeout() {
    print(String(describing: self) + ": " + #function)
  }

  
}
