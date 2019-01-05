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
import DarkTemplar

/// Packaging class
@objcMembers
public class PseudoClass: NSObject {
  
  /// Cache pool, When the `PseudoClass` is first initialized, it will be added here with `PseudoClass.methodLists()`
  public static var cache = [String: PseudoClass]()
  /// Routing class
  public var instance: NSObject
  /// Functions in the routing class
  public lazy var methodLists = getMethods()
  
  /// Routing class name
  let name: String
  /// Type of Routing class
  let type: NSObject.Type
  
  /// init
  ///
  /// - Parameter name: Routing class name
  public init?(name: String) {
    if name.isEmpty { return nil }
    
    self.name = name
    let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
    if let value = PseudoClass.cache[self.name] {
      self.type = value.type
      self.instance = value.instance
    }else if let type = NSClassFromString(name) as? NSObject.Type {
      let instance = type.init()
      self.type = type
      self.instance = instance
    } else if let type = NSClassFromString("\(namespace).\(name)") as? NSObject.Type {
      let instance = type.init()
      self.type = type
      self.instance = instance
    }else {
      return nil
    }
    super.init()
    self.methodLists = getMethods()
    PseudoClass.cache[self.name] = self
    
  }
  
  /// Get the list of object functions
  ///
  /// - Returns: [String: PseudoMethod]
  func getMethods() -> [String: PseudoMethod] {
    var list = [String: PseudoMethod]()
    findSuperClasses().forEach { (`class`) in
      var methodNum: UInt32 = 0
      let methods = class_copyMethodList(`class`, &methodNum)
      for index in (0..<numericCast(methodNum)) {
        guard let method = methods?[index] else { continue }
        let pseudoMethod = PseudoMethod(method: method)
        if list[pseudoMethod.selector.description] != nil { continue }
        list[pseudoMethod.selector.description] = pseudoMethod
      }
      free(methods)
    }
    return list
  }
  
}

// MARK: - send message
extension PseudoClass {
  
  /// Function call
  ///
  /// - Parameters:
  ///   - method: method
  ///   - args: args
  /// - Returns: return value
  @discardableResult
  func send(method: PseudoMethod, args: [Any] = []) -> Any? {
    
    let sig = instance.methodSignature(method.selector)
    let inv = Invocation(methodSignature: sig)
    inv?.target = instance
    inv?.selector = method.selector
    
    if args.count < method.paramsTypes.count - 2 {
      KhalaFailure.inconsistentNumberInSendMessage()
      return nil
    }
    
    method.paramsTypes.dropFirst(2).enumerated().forEach { (item) in
      let value = args[item.offset]
      inv?.setArgument(value, expectedTypeEncoding: item.element.rawValue, at: item.offset + 2)
    }
    
    inv?.invoke()
    
    switch method.returnType {
    case .block:
      // 目前无法解决不同类型闭包问题
      return nil
    case .object:
      return inv?.getReturnObject()
    case .longlong,.point,.int:
      var value: Int = 0
      inv?.getReturnValue(&value)
      return value
    case .float:
      var value: Float = 0.0
      inv?.getReturnValue(&value)
      return value
    case .double:
      var value: Double = 0.0
      inv?.getReturnValue(&value)
      return value
    case .bool, .char:
      var value: Bool?
      inv?.getReturnValue(&value)
      return value
    case .void:
      return nil
    case .sel:
      var value: Selector?
      inv?.getReturnValue(&value)
      return value
    default:
      return nil
    }
    
  }
  
}

// MARK: - find
extension PseudoClass {
  
  /// Search matching function
  ///
  /// - Parameter name: Function name (excluding parameter name)
  /// - Returns: Return matching function
  func findMethod(name: String) -> [PseudoMethod]? {
    let methods = methodLists.compactMap({ (item) -> PseudoMethod? in
      if let function = item.key.split(separator: ":").first, function == name {
        return item.value
      }
      return nil
    })
    
    if methods.isEmpty { return nil }
    return methods
  }
  
  /// Search for current class and parent class
  ///
  /// - Returns: Class list (not including NSObject)
  func findSuperClasses() -> [NSObject.Type] {
    var classes = [NSObject.Type]()
    var anyclass: NSObject.Type? = type
    while let `class` = anyclass {
      classes.append(`class`)
      anyclass = class_getSuperclass(`class`) as? NSObject.Type
    }
    // 放弃 NSObject 中函数
    _ = classes.popLast()
    return classes.reversed()
  }
  
}
