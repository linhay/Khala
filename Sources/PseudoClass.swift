//
//  PseudoClass.swift
//  DarkTemplar
//
//  Created by linhey on 2018/11/19.
//

import Cocoa
import DarkTemplar

public class PseudoClass: NSObject {
  
  static var cache = [String: PseudoClass]()
  
  let name: String
  let type: NSObject.Type
  public var instance: NSObject
  public var methodLists = [String: PseudoMethod]()
  
  public init?(name: String) {
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
    methods()
    PseudoClass.cache[self.name] = self
  }
  
  @discardableResult public func send(method: PseudoMethod) -> Any? {
    return send(method: method, args: [])
  }
  
  @discardableResult public func send(method: PseudoMethod, args: Any...) -> Any? {
    
    let sig = instance.methodSignature(method.selector)
    let inv = Invocation(methodSignature: sig)
    inv?.target = instance
    inv?.selector = method.selector
    
    print(method.selector,args)
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
  
  
  public func findMethod(name: String) -> PseudoMethod? {
   return methodLists[name]
  }
  
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
  
  func methods() {
    findSuperClasses().forEach { (`class`) in
      var methodNum: UInt32 = 0
      let methods = class_copyMethodList(`class`, &methodNum)
      for index in (0..<numericCast(methodNum)) {
        guard let method = methods?[index] else { continue }
        let pseudoMethod = PseudoMethod(method: method)
        self.methodLists[pseudoMethod.selector.description] = pseudoMethod
      }
      free(methods)
    }
  }
  
}
