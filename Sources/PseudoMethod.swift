//
//  PseudoMethod.swift
//  DarkTemplar
//
//  Created by linhey on 2018/11/19.
//

import Cocoa

public class PseudoMethod: NSObject {
  
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
    
    super.init()
  }
}
