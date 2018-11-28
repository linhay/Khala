//
//  PseudoClass.swift
//  DarkTemplar
//
//  Created by linhey on 2018/11/19.
//

import Foundation
import DarkTemplar

public class PseudoClass: NSObject {
  
  static var cache = [String: PseudoClass]()
  
  let name: String
  let type: NSObject.Type
  
  public var instance: NSObject
  public var methodLists = [String: PseudoMethod]()
  
  public init?(name: String,smartMatch: Bool = false) {
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


// MARK: - 智能匹配
extension PseudoClass {
  /// 智能匹配 default: false
  static var isSmartMatch = false{
    didSet{
      if isSmartMatch {
        smartList = getSmartClass()
      }else {
        smartList.removeAll()
      }
      
    }
  }
  
  /// 待匹配列表
  static var smartList = [String: NSObject.Type]()
  
  static func getSmartClass() -> [String: NSObject.Type] {
    let typeCount = Int(objc_getClassList(nil, 0))
    //存放class的已分配好的空间的数组指针
    let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
    //存放class的已分配好的空间的可选数组指针
    let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
    //获取已注册的类存放到types里
    
    objc_getClassList(autoreleasingTypes, Int32(typeCount))
    
    var list = [String: NSObject.Type]()
    for index in 0..<typeCount {
      if let type = types[index] as? KhalaProtocol.Type {
        let name = String(cString: class_getName(type))
        list[name] = type as? NSObject.Type
      }
    }
    types.deallocate()
    return list
  }
}


// MARK: - send
extension PseudoClass {
  
  @discardableResult public func send(method: PseudoMethod) -> Any? {
    return send(method: method, args: [])
  }
  
  @discardableResult public func send(method: PseudoMethod, args: [Any]) -> Any? {
    
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

//- key : "definition:success:failure:other:"
//- key : "definition::::"
//- key : "definitionWithInfo:success:failure:other:"

// MARK: - find
extension PseudoClass {
  public func findMethod(name: String) -> [PseudoMethod]? {
    let methods = methodLists.compactMap({ (item) -> PseudoMethod? in
      if let function = item.key.split(separator: ":").first, function == name {
        return item.value
      }
      return nil
    })
    
    if methods.isEmpty { return nil }
    return methods
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
}
