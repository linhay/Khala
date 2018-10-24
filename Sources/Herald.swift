//
//  Herald.swift
//  Khala
//
//  Created by linhey on 2018/10/19.
//

import Foundation
import DarkTemplar

public typealias KhalaBlock = @convention(block) (_ useInfo: [String: Any]) -> Void

public struct PseudoMethod {
  let selector: Selector
  let paramsTypes: [ObjectType]
  let returnType: ObjectType
  let typeEncoding: String
  
  init(method: Method) {
    self.selector = method_getName(method)
    
    if let typeEncoding = method_getTypeEncoding(method) {
      self.typeEncoding = String(cString: typeEncoding)
    }else{
      self.typeEncoding = ""
    }
    
    /// 返回值类型
    let tempReturnType = method_copyReturnType(method)
    self.returnType = ObjectType(char: tempReturnType)
    free(tempReturnType)
    
    /// 获取参数类型
    let arguments = method_getNumberOfArguments(method)
    self.paramsTypes = (0..<arguments).map { (index) -> ObjectType in
      guard let argumentType = method_copyArgumentType(method, index) else {
        return ObjectType.unknown
      }
      let type = ObjectType(char: argumentType)
      free(argumentType)
      return type
    }
  }
}

enum ObjectType: String {
  case void     = "v"  //void类型   v
  case sel      = ":"  //selector  :
  case object   = "@"  //对象类型   "@"
  case block    = "@?"
  case double   = "d"  //double类型 d
  case int      = "i"  //int类型    i
  case bool     = "B"  //C++中的bool或者C99中的_Bool B
  case longlong = "q"  //long long类型 q
  case point    = "^"  //          ^
  case unknown  = "."
  
  init(char: UnsafePointer<CChar>) {
    guard let str = String(utf8String: char) else {
      self = .unknown
      return
    }
    self = ObjectType(rawValue: str) ?? .unknown
  }
  
  //  case char     =     //char      c
  //  case char*    =     //char*     *
  //  case short    =     //short     s
  //  case long     =     //long      l
  //  case float    =     //float     f
  //  case `class`  =     //class     #
  //  case array    =     //[array type]
  //  case `struct` =     //{name=type…}
  //  case union    =     //(name=type…)
  //  case bnum     =     //A bit field of num bits
  //  case unsignedChar  = //unsigned char    C
  //  case unsignedInt   = //unsigned int     I
  //  case unsignedShort = //unsigned short   S
  //  case unsignedLong  = //unsigned long    L
  //  case unsignedLongLong = //unsigned short   Q
}


public class PseudoClass {
  
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
    methods()
    PseudoClass.cache[self.name] = self
  }
  
  public convenience init?(url: URL) {
    guard let host = url.host, !host.isEmpty else { return nil }
    self.init(name: host)
  }
  
  public func send(method: PseudoMethod, args: Any...) -> Any? {
    var args = args.map { (item) -> Any in
      switch item {
      case let v as Double:
        return NSNumber(value: v)
      default:
        return item
      }
    }
    let sig = instance.methodSignature(method.selector)
    let inv = Invocation(methodSignature: sig)
    inv?.target = instance
    inv?.selector = method.selector
    
    method.paramsTypes.dropFirst(2).enumerated().forEach { (item) in
      inv?.setArgument(args[item.offset], expectedTypeEncoding: item.element.rawValue, at: item.offset + 2)
    }
  
    inv?.invoke()
    if method.returnType == .void {
      return nil
    }
    var value: Any? = nil
    inv?.getReturnValue(&value)
    return value
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


class Herald {
  
}
