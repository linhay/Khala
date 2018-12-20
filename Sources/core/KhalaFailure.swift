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
  
  static func logWrite(message: String, file: StaticString = #file, line: UInt = #line) {
    let value = "[Khala] log write fail: \(message)"
    failure(value,file:file,line: line)
  }
  
  static func notFoundClass(name: String, file: StaticString = #file, line: UInt = #line) {
    let value = "[Khala] Did not match this route class:\(name)"
    failure(value,file:file,line: line)
  }
  
  static func notFoundFunc(className: String,funcName: String, methods: [String], file: StaticString = #file, line: UInt = #line) {
    let value = "[Khala] [Khala] If there is no match to the route function [\(funcName)] in the route class[\(className)], please refer to the list of functions of this class:"
      + methods
        .enumerated()
        .map{ $0.offset.description + ": " + $0.element }
        .joined(separator: "\n") + "\n"
    failure(value,file:file,line: line)
  }
  
  static func InconsistentNumberInSendMessage(file: StaticString = #file, line: UInt = #line) {
    failure("[Khala] Inconsistent number")
  }
  
  static func notURL(_ url: URL, file: StaticString = #file, line: UInt = #line) {
    let value = "[Khala] There is an error in the url composition:\(url)"
    failure(value,file:file,line: line)
  }
  
  static func multipleFunc(methods: [PseudoMethod], file: StaticString = #file, line: UInt = #line) {
    let value = "[Khala] We match multiple functions, please modify the function name in the routing class."
      + methods
        .map{ $0.selector.description }
        .joined(separator: "\n") + "\n"
    failure(value,file:file,line: line)
  }
  
  static func failure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    guard isEnabled else { return }
    assertionFailure(message,file: file,line: line)
  }
  
}
