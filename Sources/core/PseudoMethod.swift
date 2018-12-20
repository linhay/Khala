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

/// Packaging method
public class PseudoMethod: NSObject {
  
  /// Function name
  public let selector: Selector
  /// type encoding
  public let typeEncoding: String
  
  let paramsTypes: [ObjectType]
  let returnType: ObjectType
  
  public init(method: Method) {
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
