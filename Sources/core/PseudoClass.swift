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

@objcMembers
public class PseudoClass: NSObject {
  
  /// 伪类缓存
  public static var cache = [String: PseudoClass]()
  
  /// 类名
  let name: String
  
  /// 实例类型
  let type: NSObject.Type
  
  /// 实例
  public var instance: NSObject
  
  /// 函数列表
  public lazy var methodLists = getMethods()
  
  /// 初始化函数
  ///
  /// - Parameter name: 类名
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
  
  /// 获取对象函数列表
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

// MARK: - send
extension PseudoClass {
  
  /// 函数调用
  ///
  /// - Parameters:
  ///   - method: 函数
  ///   - args: 函数参数
  /// - Returns: 返回值
  @discardableResult
  func send(method: PseudoMethod, args: [Any] = []) -> Any? {
    
    let sig = instance.methodSignature(method.selector)
    let inv = Invocation(methodSignature: sig)
    inv?.target = instance
    inv?.selector = method.selector
    
    if args.count != method.paramsTypes.count - 2 {
      Khala.failure("[Khala] 参数数量不一致")
      return nil
    }
    
    method.paramsTypes.dropFirst(2).enumerated().forEach { (item) in
      var value = args[item.offset]
      let offset = item.offset + 2
      if let v = value as? String{ value = NSString(string: v) }
      inv?.setArgument(&value, at: offset)
    }
    
    inv?.invoke()
    
    switch method.returnType {
    case .block:
      // 目前无法解决不同类型闭包问题
      return nil
    case .object:
      var value = NSObject()
      inv?.getReturnValue(&value)
      if let v = value as? String { return v }
      return value
    case .longlong,.point,.int:
      var value: Int = 0
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
  
  /// 搜索匹配函数
  ///
  /// - Parameter name: 函数名称(不包括参数名)
  /// - Returns: 返回匹配函数
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
  
  /// 搜索当前类与父类
  ///
  /// - Returns: 类列表(不包括NSObject)
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