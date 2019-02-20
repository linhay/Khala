//
//  KhalaAppDelegate.swift
//  AModule
//
//  Created by linhey on 2019/2/19.
//

import UIKit

@objcMembers
public class KhalaAppDelegate: NSObject {
  
  public var classNames = Khala.regist(protocol: UIApplicationDelegate.self).filter({ $0 != "AppDelegate" && !$0.contains(".AppDelegate") })
  
  public override init() {
    super.init()
    classNames.forEach({ _ = PseudoClass(name: $0) })
  }
  
  
  public func applicationDidFinishLaunching(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach ({ $0.applicationDidFinishLaunching?(application) })
  }
  
  
  public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ return $0.application?(application, willFinishLaunchingWithOptions: launchOptions) })
  }
  
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, didFinishLaunchingWithOptions: launchOptions) })
  }
  
  public func applicationDidBecomeActive(_ application: UIApplication){
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach ({ $0.applicationDidBecomeActive?(application) })
  }
  
  public func applicationWillResignActive(_ application: UIApplication){
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach ({ $0.applicationWillResignActive?(application) })
  }
  
  public func application(_ application: UIApplication, handleOpen url: URL) -> [Bool]{
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, handleOpen: url) })
  }
  
  public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation) })
  }
  
  @available(iOS 9.0, *)
  public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(app, open: url, options: options) })
  }
  
  public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationDidReceiveMemoryWarning?(application) })
  }
  
  public func applicationWillTerminate(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationWillTerminate?(application) })
  }
  
  public func applicationSignificantTimeChange(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationSignificantTimeChange?(application) })
  }
  
  public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration) })
  }
  
  public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation) })
  }
  
  public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, willChangeStatusBarFrame: newStatusBarFrame) })
  }
  
  public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didChangeStatusBarFrame: oldStatusBarFrame) })
  }
  
  public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didRegister: notificationSettings) })
  }
  
  public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) })
  }
  
  public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) })
  }
  
  public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didReceiveRemoteNotification: userInfo) })
  }
  
  public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didReceive: notification) })
  }
  
  public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler) })
  }
  
  @available(iOS 9.0, *)
  public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({
        $0.application?(application,
                        handleActionWithIdentifier: identifier,
                        forRemoteNotification: userInfo,
                        withResponseInfo: responseInfo,
                        completionHandler: completionHandler)
      })
  }
  
  public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({
        $0.application?(application,
                        handleActionWithIdentifier: identifier,
                        forRemoteNotification: userInfo,
                        completionHandler: completionHandler)
      })
  }
  
  @available(iOS 9.0, *)
  public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void){
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({
        $0.application?(application,
                        handleActionWithIdentifier: identifier,
                        for: notification,
                        withResponseInfo: responseInfo,
                        completionHandler: completionHandler)
      })
  }
  
  @available(iOS 7.0, *)
  public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler) })
  }
  
  @available(iOS 7.0, *)
  public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, performFetchWithCompletionHandler: completionHandler) })
  }
  
  @available(iOS 9.0, *)
  public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler) })
  }
  
  @available(iOS 7.0, *)
  public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler) })
  }
  
  @available(iOS 8.2, *)
  public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply) })
  }
  
  @available(iOS 9.0, *)
  public func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationShouldRequestHealthAuthorization?(application) })
  }
  
  //  @available(iOS 11.0, *)
  //  public func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
  //    nodes
  //      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
  //      .forEach({ $0.application?(application, handle: intent, completionHandler: completionHandler) })
  //  }
  
  @available(iOS 4.0, *)
  public func applicationDidEnterBackground(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationDidEnterBackground?(application) })
  }
  
  @available(iOS 4.0, *)
  public func applicationWillEnterForeground(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationWillEnterForeground?(application) })
  }
  
  @available(iOS 4.0, *)
  public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationProtectedDataWillBecomeUnavailable?(application) })
  }
  
  @available(iOS 4.0, *)
  public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.applicationProtectedDataDidBecomeAvailable?(application) })
  }
  
  public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> [UIInterfaceOrientationMask] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, supportedInterfaceOrientationsFor: window) })
  }
  
  public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier) })
  }
  
  public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> [UIViewController] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder) })
  }
  
  public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, shouldSaveApplicationState: coder) })
  }
  
  public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, shouldRestoreApplicationState: coder) })
  }
  
  public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, willEncodeRestorableStateWith: coder) })
  }
  
  public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didDecodeRestorableStateWith: coder) })
  }
  
  public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, willContinueUserActivityWithType: userActivityType) })
  }
  
  public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> [Bool] {
    return classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .compactMap({ $0.application?(application, continue: userActivity, restorationHandler: restorationHandler) })
  }
  
  public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error) })
  }
  
  public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
    classNames
      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
      .forEach({ $0.application?(application, didUpdate: userActivity) })
  }
  
  //  public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata) {
  //    nodes
  //      .compactMap({ PseudoClass.cache[$0]?.instance as? UIApplicationDelegate })
  //      .forEach({ $0.application?(application, userDidAcceptCloudKitShareWith: cloudKitShareMetadata) })
  //  }
  
}
