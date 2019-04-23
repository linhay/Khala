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

/// Use it when your routing function needs to support the closure type.
public typealias KhalaClosure = @convention(block) (_:[String: Any]) -> Void
public typealias KhalaInfo = [String: Any]

@objcMembers
public class Khala: NSObject {
    
    /// Rewrite module
    public static var rewrite: KhalaRewrite = Rewrite.shared
    /// Logs module
    public static var history: KhalaHistory = History()
    /// url and params
    public var node: KhalaNode
    
    /// init
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - params: Use it when you need to pass NSObject/UIImage, etc.
    public init(url: URL, params: [AnyHashable: Any] = [:]) {
        node = Rewrite.separate(KhalaNodeValue(url: url,params: params))
        node = Khala.rewrite.redirect(node)
        super.init()
    }
    
    /// init
    ///
    /// - Parameters:
    ///   - str: String type URL
    ///   - params: Use it when you need to pass NSObject/UIImage, etc.
    public init?(str: String, params: [AnyHashable: Any] = [:]) {
        guard let tempURL = URL(string: str) else { return nil }
        node = Rewrite.separate(KhalaNodeValue(url: tempURL, params: params))
        node = Khala.rewrite.redirect(node)
        super.init()
    }
    
}

// MARK: - Static variable switch
extension Khala {
    
    /// Language
    ///
    /// - en: English
    /// - cn: Chinese(中文)
    public enum Language: String {
        case en
        case cn
    }
    
    /// Whether to enable assertions, the default is enabled
    public static var isEnabledAssert: Bool {
        set{ KhalaFailure.isEnabled = newValue }
        get{ return KhalaFailure.isEnabled }
    }
    /// Whether to enable the log, the default is not enabled
    public static var isEnabledLog: Bool{
        set{ history.isEnabled = newValue }
        get{ return history.isEnabled }
    }
    
    /// assertions language
    public static var language: Language{
        set{ KhalaFailure.language = newValue }
        get{ return KhalaFailure.language }
    }
    
}

// MARK: - private
extension Khala {
    
    /// Find routing class instances and routing functions
    ///
    /// - Parameters:
    ///   - value: `KhalaURLValue`
    ///   - blockCount: The number of blocks used to exactly match the function of the same name
    /// - Returns: routing class instances and routing functions or nil
    private func findInstenAndMethod(value: KhalaNode) -> (insten: KhalaClass,method: KhalaMethod)? {
        Khala.history.write(value)
        
        guard let host = value.url.host, let firstPath = value.url.pathComponents.last else {
            KhalaFailure.notURL(node.url)
            return nil
        }
        
        guard let insten = KhalaClass(name: host) else {
            KhalaFailure.notFoundClass(name: host)
            return nil
        }
        
        guard let methods = insten.findMethod(name: firstPath) else {
            KhalaFailure.notFoundFunc(className: insten.name,
                                      funcName: firstPath,
                                      methods: insten.methodLists.keys.map{ $0 })
            return nil
        }
        
        guard !methods.isEmpty else {
            KhalaFailure.notFoundFunc(className: host, funcName: firstPath, methods: insten.methodLists.map{ $0.key })
            return nil
        }
        
        guard methods.count >= 1 else {
            KhalaFailure.multipleFunc(methods: methods)
            return nil
        }
        
        guard let method = methods.first else { return nil }
        return (insten: insten,method: method)
    }
    
    /// Call routing function
    ///
    /// - Parameters:
    ///   - insten: `PseudoClass`
    ///   - method: `PseudoMethod`
    ///   - args: args for routing function
    /// - Returns: return value
    private func perform(insten: KhalaClass, method: KhalaMethod, args: [Any]) -> Any? {
        var args: [Any] = args
        
        if let index = method.paramsTypes.dropFirst(2).enumerated().first(where: { $0.element == ObjectType.object })?.offset {
            args.insert(self.node.params, at: index)
        }
        
        let value = insten.send(method: method, args: args)
        return value
    }
    
}



// MARK: - Method about regist `PseudoClass.cache`
public extension Khala {
    
    /// add `PseudoClass` to `PseudoClass.cache`
    ///
    /// You can also use `PseudoClass.cache` to achieve the same effect.
    ///
    /// - Returns: whether registration is successful
    @discardableResult
    func register() -> Bool {
        guard let host = node.url.host else {
            KhalaFailure.notURL(node.url)
            return false
        }
        
        guard KhalaClass(name: host) != nil else {
            KhalaFailure.notFoundClass(name: host)
            return false
        }
        
        return true
    }
    
    /// remove `PseudoClass` from `PseudoClass.cache`
    ///
    /// You can also use `PseudoClass.cache` to achieve the same effect.
    ///
    /// - Returns: Whether to successfully cancel the registration
    @discardableResult
    func unregister() -> Bool {
        
        guard let host = node.url.host else {
            KhalaFailure.notURL(node.url)
            return false
        }
        
        KhalaClass.cache[host] = nil
        return true
    }
    
    /// remove all value with `PseudoClass.cache`
    ///
    /// You can also use `PseudoClass.cache` to achieve the same effect.
    class func unregisterAll() {
        KhalaClass.cache.removeAll()
    }
    
}

// MARK: - Method about call routing function
public extension Khala {
    
    /** call routing function
     
     ```
     let value = Khala(str: "kl://AModule/doSomething")?.call()
     ```
     
     - Returns: Any?
     */
    @discardableResult
    func call() -> Any? {
        guard let ir = self.findInstenAndMethod(value: self.node) else { return nil }
        let closures: [KhalaClosure] = ir.method.paramsTypes.dropFirst(2).compactMap { (item) -> KhalaClosure? in
            if item == ObjectType.block { return { (useInfo) in  } }
            else { return nil }
        }
        return perform(insten: ir.insten, method: ir.method, args: closures)
    }
    
    /** call routing function with closure
     
     ```
     let value = Khala(str: "kl://AModule/doSomething")?.call(block: { (item) in
     item is [String: AnyHashable]
     })
     ```
     
     - Parameter block: KhalaClosure
     - Returns: Any?
     */
    @discardableResult
    func call(block: @escaping KhalaClosure) -> Any? {
        guard let ir = self.findInstenAndMethod(value: self.node) else { return nil }
        return perform(insten: ir.insten, method: ir.method, args: [block])
    }
    
    /** call routing function with closure
     
     ```
     let value = Khala(str: "kl://AModule/doSomething")?.call(blocks: [{ (item) in
     // 1 block
     }, { (item) in
     // 2 block
     }, { (item) in
     // 3 block
     }])
     ```
     
     - Parameter blocks: [KhalaClosure]
     - Returns: Any?
     */
    @discardableResult
    func call(blocks: [KhalaClosure]) -> Any? {
        guard let ir = self.findInstenAndMethod(value: self.node) else { return nil }
        return perform(insten: ir.insten, method: ir.method, args: blocks)
    }
    
    /** call routing function with closure
     
     ```
     let value = Khala(str: "kl://AModule/doSomething")?.call(blocks: { (item) in
     // 1 block
     }, { (item) in
     // 2 block
     }, { (item) in
     // 3 block
     })
     ```
     
     - Parameter blocks: [KhalaClosure]
     - Returns: Any?
     */
    func call(blocks: KhalaClosure...) -> Any? {
        guard let ir = self.findInstenAndMethod(value: self.node) else { return nil }
        return perform(insten: ir.insten, method: ir.method, args: blocks)
    }
}
