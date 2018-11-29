import Foundation

public protocol KhalaProtocol: NSObjectProtocol { }


public typealias KhalaClosure =  @convention(block) (_ useInfo: [String: Any]) -> Void
public typealias URLValue = (url: URL, params: [AnyHashable: Any])

public class Khala: NSObject {
  
  public var rewrite = Rewrite.default

  private var history = History()
  
  public var urlValue: URLValue
  
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = rewrite.separate((url,params))
    super.init()
  }
  
  public init?(url: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: url) else { return nil }
    urlValue = rewrite.separate((tempURL,params))
    super.init()
  }
  
}

// MARK: - static
extension Khala {
  
  /// 是否开启断言, 默认开启
  public static var isEnabledAssert = true
  
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

// MARK: - middleware
extension Khala {
  
  private func middleForCall(value: URLValue, blockCount: Int) -> (insten: PseudoClass,method: PseudoMethod)? {
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
  
  private func send(insten: PseudoClass, method: PseudoMethod, args: [Any]) -> Any? {
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
  
  @discardableResult
  public func call() -> Any? {
    guard let middle = self.middleForCall(value: self.urlValue, blockCount: 0) else { return nil }
    return send(insten: middle.insten, method: middle.method, args: [])

  }
  
  @discardableResult
  public func call(block: @escaping KhalaClosure) -> Any? {
    guard let middle = self.middleForCall(value: self.urlValue, blockCount: 1) else { return nil }
    return send(insten: middle.insten, method: middle.method, args: [block])
  }
  
  @discardableResult
  public func call(blocks: KhalaClosure...) -> Any? {
    guard let middle = self.middleForCall(value: self.urlValue, blockCount: blocks.count) else { return nil }
    return send(insten: middle.insten, method: middle.method, args: blocks)
  }
  
}
