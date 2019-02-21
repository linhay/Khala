# [Khala](https://github.com/linhay/Khala)

![](https://s.linhey.com/Khala-logo.png)

[![CI Status](https://api.travis-ci.com/linhay/Khala.svg)](https://travis-ci.org/linhay/Khala)
[![Version](https://img.shields.io/cocoapods/v/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![License](https://img.shields.io/cocoapods/l/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![Platform](https://img.shields.io/cocoapods/p/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)


Swift 路由和模块通信解耦工具和规范。 可以让模块间无耦合的调用服务、页面跳转。

> [**English Introduction**](./readme_en.md)

## 特性

- [x] 支持 cocopods 组件化开发.
- [x] 无需注册URL,采用runtime来实现`target-action`形式函数调用.
- [x] 内置URL重定向模块.
- [x] 内置日志模块.
- [x] 支持模块自定义.
- [x] 内置断言,可切换语言.
- [x] 路由类支持`UIApplicationDelegate`管理.
- [x] 优先支持swift.

## 要求

- **iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+**

- **Swift 4.x**

## 安装

```ruby
pod 'Khala'
```

## 定义

> 有部分内容无法准确定义,在此个人擅自定义以下名词.

1. **路由类:**  负责接收路由事件的`NSOBject`类.
2. **路由函数:** 路由类中 负责接收路由事件的函数.

## 快速使用

1. **URL**

   在Khala中,最原始的URL结构为:

   ```verilog
   scheme://[route class]/[route function]?key1=value1&key2=value2
   ```

   > 但是你可以编写重定向规则来实现复杂的URL结构,与权限控制.

2. **首先我们定义2个独立的路由类文件, 并且将其分别封装至2个pod库中.**

   > 该部分内容可以下载示例工程体验.

   - **AModule.swift**

     ```swift
     import UIKit
     import Khala
     
     @objc(AModule) @objcMembers
     class AModule: NSObject {
        
       func doSomething(_ info: [String: Any]) -> String {
         return description
       }
       
       func server(_ info: [String: Any]) -> Int {
         guard let value = info["value"] as? String, let res = Int(value) else {
             return 0 
         }
         return res
       }
       
       func forClosure(_ closure: KhalaClosure) {
         closure(["value": #function])
       }
       
       func forClosures(_ success: KhalaClosure, failure: KhalaClosure) {
         success(["success": #function])
         failure(["failure": #function])
       }
     
     }
     ```

   - **BModule.swift**

     ```swift
     import UIKit
     import Khala
     
     @objc(BModule) @objcMembers
     class BModule: NSObject {
       
       func doSomething(_ info: [String: Any]) -> String {
         return description
       }
       
     }
     ```

3. **通过URL执行路由函数:** [**Khala**](https://linhay.github.io/Khala/Classes/Khala.html)

   - 普通调用: 

     ```swift
     // 2. 不保持参数类型,(url中参数类型皆为String)
     let value = Khala(str: "kl://AModule/server2?value=64")?.call() as? Int
     print(value ?? "nil")
     /// Print: 64
     ```

   - 异步调用:

     ```swift
     /// 单个block调用
     Khala(str: "kf://AModule/forClosure")?.call(block: { (item) in
      	print("forClosure:", item)
     })
     /// Print: forClosure: ["value": "forClosure"]
     // 
     
     
     /// 多个block调用
     Khala(str: "kf://AModule/forClosures")?.call(blocks: { (item) in
      	print("forClosures block3:", item)
     },{ (item) in
      	print("forClosure block4:", item)
     })
     //Print: forClosures block3: ["success": "forClosures(_:failure:)"]
     //Print: forClosure block4: ["failure": "forClosures(_:failure:)"]
     
     /// or
     Khala(str: "kf://AModule/forClosures")?.call(blocks: [{ (item) in
      	print("forClosures block1:", item)
     },{ (item) in
     	print("forClosure block2:", item)
     }])
     
     //Print: forClosures block1: ["success": "forClosures(_:failure:)"]
     //Print: forClosure block2: ["failure": "forClosures(_:failure:)"]
     ```

   - **UIKit/AppKit 扩展调用**:

     ```swift
     let vc = Khala(str: "kl://BModule/vc?style=0")?.viewController
     ```

4. **路由通知  [KhalaNotify](https://linhay.github.io/Khala/Classes/KhalaNotify.html)**

   可以使用该类型来执行多个已缓存路由类中的同名函数.

   ```swift
   // 缓存 AModule 与 BModule 路由类.
   Khala(str: "kl://AModule")?.regist()
   Khala(str: "kl://BModule")?.regist()
       
   // 执行通知
   let value = KhalaNotify(str: "kl://doSomething?value=888")?.call()
   print(value ?? "")
   
   // Print: [<BModule: 0x60000242f230>, <AModule: 0x600002419d10>]
   ```

   > 通知只能发送至已被缓存的路由类中. 缓存路径:  [**KhalaClass.cache**](https://linhay.github.io/Khala/Classes/KhalaClass.html#/c:@M@Khala@objc(cs)KhalaClass(cpy)cache)

5. **路由注册**

   在 [**Khala**](https://linhay.github.io/Khala/Classes/Khala.html#/c:@CM@Khala@objc(cs)Khala(im)register)中我提供了以下接口来抽象  [**KhalaClass.cache**](https://linhay.github.io/Khala/Classes/KhalaClass.html#/c:@M@Khala@objc(cs)KhalaClass(cpy)cache):

   ```swift
   /// 注册路由类, 等同于Khala(str: "kl://AModule/doSomething")
   func register() -> Bool
   // 取消注册路由类, 等同于 KhalaClass.cache["AModule"] = nil
   func unregister() -> Bool
   // 取消全部注册路由类, 等同于 KhalaClass.cache.removeAll()
   func unregisterAll() -> Bool
   // 批量注册遵守Protocol协议的路由类:
   Khala.regist(protocol: Protocol)
   ```

6. **URL重定向:** [**KhalaRewrite**](https://linhay.github.io/Khala/Protocols/KhalaRewrite.html)

   若开发者需要自定义路由解析规则或重定向路由函数,这部分则尤为重要.

   1. 构造规则:

      ```swift
      let filter = RewriteFilter {
       if $0.url.host == "AModule" {
      	var urlComponents = URLComponents(url: $0.url, resolvingAgainstBaseURL: true)!
      	urlComponents.host = "BModule"
      	$0.url = urlComponents.url!
       }
      	return $0
      }
      ```

   2. 添加至全局规则池

      ```swift
      Khala.rewrite.filters.append(filter)
      ```

   3. 请求调用

      ```swift
      let value = Khala(str: "kl://AModule/doSomething")?.call()
      print(value ?? "nil")
      /// Print: <BModule: 0x6000026e2800>
      ```

7.  **UIApplicationDelegate 生命周期分发**

   部分组件往往依赖于主工程中的`AppDelegate`中部分函数.

   1. 在`Khala`中,需要显式的在主工程中的`AppDelegate`调用与处理相关逻辑.
   2. 服务类需要遵守`UIApplicationDelegate`协议.

   主工程`AppDelegate`:

   ```swift
   @UIApplicationMain
   class AppDelegate: UIResponder,UIApplicationDelegate {
   
     var window: UIWindow?
   
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       let list = Khala.appDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
       return true
     }
       
   }
   ```

   组件中服务类:

   ```swift
   @objc(AModule) @objcMembers
   class AModule: NSObject,UIApplicationDelegate {
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       print("AModule.didFinishLaunchingWithOptions")
       return true
     }
     
   }
   ```

8. **日志模块:** [**KhalaHistory**](https://linhay.github.io/Khala/Protocols/KhalaHistory.html)

   每一份url请求都将记录至日志文件中, 可以在适当的时候提供开发者便利.

   1. 开启日志(默认关闭)

      ```swift
      Khala.isEnabledLog = true
      // or 
      Khala.history.isEnabled = true
      ```

   2. 文件路径: `/Documents/khala/logs/`

   3.  文件内容:  日期 + 时间 + URL + 参数 

      ```verilog
      2018-12-01 02:06:54  kl://SwiftClass/double?  {"test":"666"}
      2018-12-01 02:06:54  kl://SwiftClass/double  {"test":"666"}
      ```

9. **扩展机制:**  [**KhalaStore**](https://linhay.github.io/Khala/Classes.html#/c:@M@Khala@objc(cs)KhalaStore)

   ***khala*** 库中提供了一个空置的类[***KhalaStore***]用于盛放**路由函数**对应的本地函数.来简化本地调用复杂度的问题.

   ```swift
   extension KhalaStore { 
    class func aModule_server(value: Int) -> Int {
       return Khala(str: "kf://AModule/server", params: ["value": value])!.call() as! Int
     }
   }
     
   @objc(AModule) @objcMembers
   class AModule: NSObject {
    func server(_ info: [String: Any]) -> Int {
       return info["value"] as? Int ?? 0
     }
   }
   
   let value = KhalaStore.aModule_server(value: 46)
   ```

   > ps: KhalaStore 扩展文件建议统一放置.

10. **断言机制**

   为方便开发者使用,添加了部分场景下断言机制,示例:

   ```verilog
   khala.iOS Fatal error: [Khala] 未在[AModule]中匹配到函数[server], 请查看函数列表:
   0: init
   1: doSomething:
   2: vc
   ```

   关闭断言(默认开启):

   ```swift
   Khala.isEnabledAssert = false
   ```

11. **缓存机制:** [**KhalaClass.cache**](https://linhay.github.io/Khala/Classes/KhalaClass.html#/c:@M@Khala@objc(cs)KhalaClass(cpy)cache)

   - 当路由第一次调用/注册路由类时,该路由类将被缓存至 [**KhalaClass.cache**](https://linhay.github.io/Khala/Classes/KhalaClass.html#/c:@M@Khala@objc(cs)KhalaClass(cpy)cache) 中, 以提高二次查找性能.
   - 当路由类实例化时,该路由类中的函数列表将被缓存至 [**KhalaClass().methodLists**](https://linhay.github.io/Khala/Classes/KhalaClass.html#/c:@M@Khala@objc(cs)KhalaClass(py)methodLists)中, 以提高查找性能.

## 注意事项

1. **路由类**

   **限制:** 

    1. 路由类必须继承自 `NSObject`

    2. 需要添加`@objc(class_name) `要防止编译器移除该类.

       > 编译器会在编译时检查swift文件中未被调用的类,并移除.(>= swift 3.0)

   **示例:**

   ```swift
   // 推荐
   @objc(AModule) @objcMembers
   class AModule: NSObject {
    func server1(_ info: [String: Any]) -> Int { ... }
    func server2(_ info: [String: Any]) -> Int { ... }
   }
   
   // 也行
   @objc(BModule)
   class AModule: NSObject {
    @objc func server1(_ info: [String: Any]) -> Int { ... }
    @objc func server2(_ info: [String: Any]) -> Int { ... }
   }
   ```

2. **路由函数**

   **限制:**

    1. **不支持**函数重载.例如:

       ```swift
       @objc(AModule) @objcMembers
       class AModule: NSObject {
        func server(_ info: [String: Any]) -> Int { ... }
        func server(_ info: [String: Any], closure: KhalaClosure) -> Int { ... }
       }
       ```

       > 缘由: khala 缓存了路由类中的函数列表, 键名为第一个`:`前的字符串.

   	2. **推荐**第一个参数采用匿名参数,方便阅读.

   	3. 参数格式**只支持**

       - 单个: `[AnyHashable: Any]`, 无顺序要求:

       - 多个: `KhalaClosure`, 有顺序要求:

         ```swift
         typealias KhalaClosure = @convention(block) (_ useInfo: [String: Any]) -> Void
         ```

       **示例:**

       ```swift
       @objc(AModule) @objcMembers
       class AModule: NSObject {
        func server1() -> Int { ... }
        func server2(info: [String: Any]) -> Int { ... }
        func server3(_ info: [String: Any]) -> Int { ... }
        func server4(_ info: [String: Any], closure: KhalaClosure) -> Int { ... }
        func server5(_ info: [String: Any], success: KhalaClosure,failure: KhalaClosure, 
       complete: KhalaClosure) -> Int { ... }
         func server6(_ success: KhalaClosure,failure: KhalaClosure, info: [String: Any],
       complete: KhalaClosure) -> Int { ... }
       }
       ```

       > 缘由:
       >
       >  `block` 为结构体类型,无法抽象出基类或者协议.
       >
       > `[String: Any]` 会适当的插入 `[KhalaClosure]`中组成参数列表.
       >
       > ps: 调用方 `KhalaClosure` 数目需要比路由函数多或者持平.否则会触发断言.

3. ***Khala*** 初始化函数

   - `params`中的参数会保持传入的类型,例如传递 `UIImage`等对象.

   ```swift
   public class Khala: NSObject {
   	public init(url: URL, params: [AnyHashable: Any] = [:]) { ... }
   	public init?(str: String, params: [AnyHashable: Any] = [:]) { ... } 
   }
   ```

## 进阶用法

1. **自定义 重定向模块**

   1. 继承 `KhalaRewrite` 协议.

   2. 替换重定向模块

      ```
      Khala.rewrite = CustomRewrite()
      ```

2. **自定义 日志模块**

   1. 继承 `KhalaHistory` 协议.

   2. 替换日志模块

      ```swift
      Khala.history = CustomHistory()
      ```


## 任务列表

- [ ] 完善 Objective-C 调用
- [ ] 完善demo示例.
- [ ] 日志模块采用*mmap*读写(解决crash部分日志未写入文件).
- [ ] 英文注释与文档.

## 文档

- [**API Reference**](https://linhay.github.io/Khala/) - 更详细的参考api文档.
- [**iOS路由(Khala)设计**](https://www.linhey.com/2019/02/20/[iOS]Khala%E8%B7%AF%E7%94%B1%E7%BB%84%E4%BB%B6%E8%A7%A3%E6%9E%84/) - khala的选型与模组化中的角色担当.

## 参考与致谢

- [**CTMediator**](https://github.com/casatwy/CTMediator): 由 [***Casa***](https://github.com/casatwy) 创建的 `Target-Action` 形式解耦路由.
- [**Routable**](https://github.com/linhay/Routable): [**khala**](https://github.com/linhay/Khala) 的前身, 正式投入生产环境迭代2年.
- [**星际争霸**](https://sc2.blizzard.cn/home): [**khala**](https://github.com/linhay/Khala) 名称源自[**星际争霸**](https://sc2.blizzard.cn/home)背景设定中达拉姆星灵的主要宗教，它基于一种由信徒之间的灵能链接而形成的哲学。 

## 作者

linhay, is.linhay@outlook.com

## License

Khala is available under the MIT license. See the LICENSE file for more info.
