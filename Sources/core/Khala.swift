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

public typealias KhalaClosure =  @convention(block) (_ useInfo: [String: Any]) -> Void

@objcMembers
public class Khala: NSObject {
  
  /// rewrite实体类
  public var rewrite: KhalaRewrite = Rewrite.shared
  public var urlValue: KhalaURLValue
  /// 日志实体类
  public var history: KhalaHistory = History()
  
  
  /// 初始化函数
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: 需要传递参数
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = Rewrite.separate(URLValue(url: url,params: params))
    urlValue = rewrite.redirect(urlValue)
    super.init()
  }
  
  /// 初始化函数
  ///
  /// - Parameters:
  ///   - str: url string 类型
  ///   - params: 需要传递参数
  public init?(str: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: str) else { return nil }
    urlValue = Rewrite.separate(URLValue(url: tempURL, params: params))
    urlValue = rewrite.redirect(urlValue)
    super.init()
  }
  
}

// MARK: - static
extension Khala {
  
  /// 是否开启断言, 默认开启
  public static var isEnabledAssert = true
  /// 是否开启日志
  public static var isEnabledLog = false
  /// 是否开启控制台s输出
  public static var isEnabledPrint = false

  /// 失败断言
  ///
  /// - Parameters:
  ///   - message: 描述
  ///   - file: 文件
  ///   - line: 行数
  static func failure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
  if !Khala.isEnabledAssert { return }
  assertionFailure(message,file: file,line: line)
}
  
}

// MARK: - private
extension Khala {
  
  /// 查询路由类实例与路由函数
  ///
  /// - Parameters:
  ///   - value: `KhalaURLValue`
  ///   - blockCount: block 数量, 用于精确匹配同名函数
  /// - Returns: 路由类实例与路由函数 or nil
  private func findInstenAndMethod(value: KhalaURLValue, blockCount: Int) -> (insten: PseudoClass,method: PseudoMethod)? {
    history.write(value)
    
    guard let host = value.url.host, let firstPath = value.url.pathComponents.last else {
      let message = "[Khala] url有误:\(urlValue.url)"
      Khala.failure(message)
      return nil
    }
    
    guard let insten = PseudoClass(name: host) else {
      let message = "[Khala] 未匹配到该类:\(host)"
      Khala.failure(message)
      return nil
    }
    
    guard var methods = insten.findMethod(name: firstPath) else {
      let message = "[Khala] 未匹配到该函数[\(firstPath)]:\n" + insten.methodLists.map({ $0.key }).joined(separator: "\n") + "\n"
      Khala.failure(message)
      return nil
    }
    
    
    methods = methods.filter({ (item) -> Bool in
      let count = item.paramsTypes.filter({ $0 == ObjectType.block }).count
      return blockCount >= count
    })
    
    
    guard methods.count == 1 else {
      let message = "[Khala] 匹配到多个函数[\(firstPath)]:\n" + methods.map({ $0.selector.description }).joined(separator: "\n") + "\n"
      Khala.failure(message)
      return nil
    }
    
    guard let method = methods.first else { return nil }
    
    return (insten: insten,method: method)
  }
  
  /// 调用路由函数
  ///
  /// - Parameters:
  ///   - insten: 伪类实例
  ///   - method: 函数伪类实例
  ///   - args: 函数参数
  /// - Returns: 返回值 or nil
  private func perform(insten: PseudoClass, method: PseudoMethod, args: [Any]) -> Any? {
    var args: [Any] = args
    
    if let index = method.paramsTypes.dropFirst(2).enumerated().first(where: { $0.element == ObjectType.object })?.offset {
      args.insert(self.urlValue.params, at: index)
    }
    
    let value = insten.send(method: method, args: args)
    return value
  }
  
}


// call
public extension Khala {
  
  /// 函数调用
  ///
  /// - Returns: 返回值 or nil
  @discardableResult
  public func call() -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: 0) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: [])
    
  }
  
  /// 函数调用
  ///
  /// - Parameter block: KhalaClosure 形式block
  /// - Returns: 返回值 or nil
  @discardableResult
  public func call(block: @escaping KhalaClosure) -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: 1) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: [block])
  }
  
  /// 函数调用
  ///
  /// - Parameter blocks: KhalaClosure 形式 block 数组
  /// - Returns: 返回值 or nil
  @discardableResult
  public func call(blocks: [KhalaClosure]) -> Any? {
    guard let middle = self.findInstenAndMethod(value: self.urlValue, blockCount: blocks.count) else { return nil }
    return perform(insten: middle.insten, method: middle.method, args: blocks)
  }
  
}
