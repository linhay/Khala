import Foundation

public typealias KhalaBlock = @convention(block) (_ useInfo: [String: Any]) -> Void
public typealias URLValue = (url: URL, params: [AnyHashable: Any])

public class KhalaClose: NSObject {
  
  var block: KhalaBlock?
  
  init(_ block: @escaping KhalaBlock) {
    super.init()
    self.block = block
  }
  
}

public class Khala: NSObject {
  
  static var rewrite = Rewrite()
  
  /// 拆分 url 与 params
  static func separate(_ value: URLValue) -> URLValue {
    var value = value
    var components = URLComponents(url: value.url, resolvingAgainstBaseURL: true)
    components?.queryItems?.forEach({ (item) in
      if value.params[item.name] == nil {
        value.params[item.name] = item.value
      }
    })
    components?.queryItems?.removeAll()
    
    guard let redirectURL = components?.url else {
      return value
    }
    value.url = redirectURL
    return value
  }
  
  /// 是否开启断言, 默认开启
  static var isEnabledAssert = true
  
  /// 失败断言
  ///
  /// - Parameters:
  ///   - message: 描述
  ///   - file: 文件
  ///   - line: 行数
  public static func failure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    if !Khala.isEnabledAssert { return }
    assertionFailure(message,file: file,line: line)
  }
  
  var history = History()
  
  public var urlValue: URLValue
  
  var queue: DispatchQueue? = nil
  
  public init(url: URL, params: [AnyHashable: Any] = [:]) {
    urlValue = Khala.separate((url,params))
    super.init()
  }
  
  public init?(url: String, params: [AnyHashable: Any] = [:]) {
    guard let tempURL = URL(string: url) else { return nil }
    urlValue = Khala.separate((tempURL,params))
    super.init()
  }
  
  /// url 与 params 转换
  func rewrite(value: URLValue) -> URLValue {
    return Khala.rewrite.redirect(value)
  }
  
  public func queue(_ value: DispatchQueue) -> Self {
    self.queue = value
    return self
  }
  
  
  
  @discardableResult
  public func call() -> Any? {
    history.write(urlValue)
    
    guard let host = urlValue.url.host else { return nil }
    guard let firstPath = urlValue.url.pathComponents.last else { return nil }
    
    guard let insten = PseudoClass(name: host) else { return nil }
    guard let method = insten.findMethod(name: firstPath) else { return nil }
    
    let value = insten.send(method: method, args: urlValue.params)
    
    return value
  }
  
  
  @discardableResult
  public func call(block: KhalaBlock) -> Any? {
    history.write(urlValue)
    return nil
  }
  
  @discardableResult
  public func call(blocks: [KhalaBlock]) -> Any? {
    let url = self.urlValue.url
    let paths = url.pathComponents
    guard let className = url.host else {
      Khala.failure("Khala: url 格式错误 " + url.absoluteString)
      return nil
    }
    
    guard var pseudoClass = PseudoClass(name: className) else {
      Khala.failure("Khala: 无法创建对应路由类" + url.absoluteString)
      return nil
    }
    
    
    guard let methodName = paths.first, let method = pseudoClass.methodLists[methodName] else {
      return nil
    }
    
    
    return nil
  }
  
  
}

