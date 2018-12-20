//
//  Khala
//
//  Copyright (c) 2018 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation

/// Use it when your routing function needs to support the closure type.
public typealias KhalaClosure = @convention(block) (_ useInfo: [String: Any]) -> Void

@objcMembers
public class Khala: NSObject {
  
  /// Rewrite module
  public static var rewrite: KhalaRewrite = Rewrite.shared
  /// Logs module
  public static var history: KhalaHistory = History()
  /// url and params
  public var urlValue: KhalaURLValue
  
  /// init
  ///
  /// - Parameters:
  ///   - url: URL
  ///   - params: Use it when you need to pass NSObject/UIImage, etc.
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = Rewrite.separate(URLValue(url: url,params: params))
    urlValue = Khala.rewrite.redirect(urlValue)
    super.init()
  }
  
  /// init
  ///
  /// - Parameters:
  ///   - str: String type URL
  ///   - params: Use it when you need to pass NSObject/UIImage, etc.
  public init?(str: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: str) else { return nil }
    urlValue = Rewrite.separate(URLValue(url: tempURL, params: params))
    urlValue = Khala.rewrite.redirect(urlValue)
    super.init()
  }
  
}

// MARK: - Static variable switch
extension Khala {
  
  /// Whether to enable assertions, the default is enabled
  public static var isEnabledAssert = true
  /// Whether to enable the log, the default is not enabled
  public static var isEnabledLog = false
  
  /// failure assertion
  ///
  /// - Parameters:
  ///   - message: A string to print in a playground or `-Onone` build. The
  ///     default is an empty string.
  ///   - file: The file name to print with `message`. The default is the file
  ///     where `assertionFailure(_:file:line:)` is called.
  ///   - line: The line number to print along with `message`. The default is the
  ///     line number where `assertionFailure(_:file:line:)` is called.
  static func failure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    if Khala.isEnabledAssert {
      assertionFailure(message,file: file,line: line)
    }
  }
  
}

// MARK: - private
extension Khala {
  
  /// Find routing class instances and routing functions
  ///
  /// - Parameters:
  ///   - value: `KhalaURLValue`
  ///   - blockCount: The number of blocks used to exactly match the function of the same name
  /// - Returns: routing class instances and routing functions or nil
  private func findInstenAndMethod(value: KhalaURLValue, blockCount: Int) -> (insten: PseudoClass,method: PseudoMethod)? {
    Khala.history.write(value)
    
    guard let host = value.url.host, let firstPath = value.url.pathComponents.last else {
      Khala.failure("[Khala] There is an error in the url composition:\(urlValue.url)")
      return nil
    }
    
    guard let insten = PseudoClass(name: host) else {
      Khala.failure("[Khala] Did not match this route class:\(host)")
      return nil
    }
    
    guard var methods = insten.findMethod(name: firstPath) else {
      let message = "[Khala] If there is no match to the route function [\(firstPath)] in the route class[\(insten.name)], please refer to the list of functions of this class:"
        + insten.methodLists.enumerated()
          .map({ $0.offset.description + ": " + $0.element.key })
          .joined(separator: "\n") + "\n"
      Khala.failure(message)
      return nil
    }
    
    
    methods = methods.filter({ (item) -> Bool in
      let count = item.paramsTypes.filter({ $0 == ObjectType.block }).count
      return blockCount >= count
    })
    
    
    guard methods.count == 1 else {
      let message = "[Khala] We match multiple functions, please modify the function name in the routing class." + methods.map({ $0.selector.description }).joined(separator: "\n") + "\n"
      Khala.failure(message)
      return nil
    }
    
    guard let method = methods.first else { return nil }
    
    return (insten: insten,method: method)
  }
  
  /// Call routing function
  ///
  /// - Parameters:
  ///   - insten: `PseudoClass`
  ///   - method: `PseudoMethod`
  ///   - args: args for routing function
  /// - Returns: return value
  private func perform(insten: PseudoClass, method: PseudoMethod, args: [Any]) -> Any? {
    var args: [Any] = args
    
    if let index = method.paramsTypes.dropFirst(2).enumerated().first(where: { $0.element == ObjectType.object })?.offset {
      args.insert(self.urlValue.params, at: index)
    }
    
    let value = insten.send(method: method, args: args)
    return value
  }
  
}



// MARK: - Method about regist `PseudoClass.cache`
public extension Khala {
  
  /// add `PseudoClass` to `PseudoClass.cache`
  ///
  /// You can also use `PseudoClass.cache` to achieve the same effect.
  ///
  /// - Returns: whether registration is successful
  @discardableResult
  public func register() -> Bool {
    guard let host = urlValue.url.host else {
      Khala.failure("[Khala] There is an error in the url composition:\(urlValue.url)")
      return false
    }
    
    guard PseudoClass(name: host) != nil else {
      Khala.failure("[Khala] Did not match this route class:\(host)")
      return false
    }
    
    return true
  }
  
  /// remove `PseudoClass` from `PseudoClass.cache`
  ///
  /// You can also use `PseudoClass.cache` to achieve the same effect.
  ///
  /// - Returns: Whether to successfully cancel the registration
  @discardableResult
  public func unregister() -> Bool {
    
    guard let host = urlValue.url.host else {
      Khala.failure("[Khala] There is an error in the url composition:\(urlValue.url)")
      return false
    }
    
    PseudoClass.cache[host] = nil
    return true
  }
  
  /// remove all value with `PseudoClass.cache`
  ///
  /// You can also use `PseudoClass.cache` to achieve the same effect.
  public class func unregisterAll() {
    PseudoClass.cache.removeAll()
  }
  
}

// MARK: - Method about call routing function
public extension Khala {
  
  /** call routing function
   
   ```
   let value = Khala(str: "kl://AModule/doSomething")?.call()
   ```
   
   - Returns: Any?
   */
  @discardableResult
  public func call() -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: 0) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: [])
  }
  
  /** call routing function with closure
   
   ```
   let value = Khala(str: "kl://AModule/doSomething")?.call(block: { (item) in
   item is [String: AnyHashable]
   })
   ```
   
   - Parameter block: KhalaClosure
   - Returns: Any?
   */
  @discardableResult
  public func call(block: @escaping KhalaClosure) -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: 1) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: [block])
  }
  
  /** call routing function with closure
   
   ```
   let value = Khala(str: "kl://AModule/doSomething")?.call(blocks: [{ (item) in
   // 1 block
   }, { (item) in
   // 2 block
   }, { (item) in
   // 3 block
   }])
   ```
   
   - Parameter blocks: [KhalaClosure]
   - Returns: Any?
   */
  @discardableResult
  public func call(blocks: [KhalaClosure]) -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: blocks.count) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: blocks)
  }
  
  /** call routing function with closure
   
   ```
   let value = Khala(str: "kl://AModule/doSomething")?.call(blocks: { (item) in
   // 1 block
   }, { (item) in
   // 2 block
   }, { (item) in
   // 3 block
   })
   ```
   
   - Parameter blocks: [KhalaClosure]
   - Returns: Any?
   */
  public func call(blocks: KhalaClosure...) -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: blocks.count) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: blocks)
  }
}
