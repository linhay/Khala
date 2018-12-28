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


struct KhalaFailure {
  
  static var isEnabled = true
  static var language = Khala.Language.en
  
  static func logWrite(message: String, file: StaticString = #file, line: UInt = #line) {
    var value = ""
    switch language {
    case .cn:
      value += "[Khala] 日志写入失败: \(message)"
    case .en:
      value += "[Khala] log write fail: \(message)"
    }
    failure(value,file:file,line: line)
  }
  
  static func notFoundClass(name: String, file: StaticString = #file, line: UInt = #line) {
    var value = ""
    switch language {
    case .cn:
      value += "[Khala] 未匹配到相应路由类:\(name)"
    case .en:
      value += "[Khala] Did not match this route class:\(name)"
    }
    failure(value,file:file,line: line)
  }
  
  static func notFoundFunc(className: String,funcName: String, methods: [String], file: StaticString = #file, line: UInt = #line) {
    var value = methods
      .enumerated()
      .map{ $0.offset.description + ": " + $0.element }
      .joined(separator: "\n") 
    
    switch language {
    case .cn:
      value = "[Khala] 未在路由类[\(className)]中查询到该路由函数[\(funcName)], 请查阅该类路由函数列表: \n" + value
    case .en:
      value = "[Khala] If there is no match to the route function [\(funcName)] in the route class[\(className)], please refer to the list of functions of this class: \n" + value
    }
    failure(value,file:file,line: line)
  }
  
  static func inconsistentNumberInSendMessage(file: StaticString = #file, line: UInt = #line) {
    var value = ""
    switch language {
    case .cn:
      value += "[Khala] 参数数目错误"
    case .en:
      value += "[Khala] Inconsistent number"
    }
    failure(value,file:file,line: line)
  }
  
  static func notURL(_ url: URL, file: StaticString = #file, line: UInt = #line) {
    var value = ""
    switch language {
    case .cn:
      value += "[Khala] URL 错误: \(url)"
    case .en:
      value += "[Khala] There is an error in the url composition: \(url)"
    }
    failure(value,file:file,line: line)
  }
  
  static func multipleFunc(methods: [PseudoMethod], file: StaticString = #file, line: UInt = #line) {
    var value = methods
      .map{ $0.selector.description }
      .joined(separator: "\n")
    
    switch language {
    case .cn:
      value = "[Khala] 匹配到多个路由函数, 请修改路由类中的路由函数名称: \n" + value
    case .en:
      value = "[Khala] We match multiple functions, please modify the function name in the routing class: \n" + value
    }
    failure(value,file:file,line: line)
  }
  
  static func failure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    guard isEnabled else { return }
    assertionFailure("\n" + message() + "\n",file: file,line: line)
  }
  
}
