# [Khala](https://github.com/linhay/Khala)

![](https://s.linhey.com/khala.png)

[![CI Status](https://img.shields.io/travis/linhay/Khala.svg?style=flat)](https://travis-ci.org/linhay/Khala)
[![Version](https://img.shields.io/cocoapods/v/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![License](https://img.shields.io/cocoapods/l/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![Platform](https://img.shields.io/cocoapods/p/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)


Swift 路由和模块通信解耦工具和规范。 可以让模块间无耦合的调用服务、页面跳转。

> [**English Introduction**](./readme_en.md)

## 任务列表

- [ ] 完善demo示例.
- [ ] 日志模块采用*mmap*读写(解决crash部分日志未写入文件).
- [ ] 英文注释与文档.

## 要求

- **iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+**

- **Swift 4.x**

## 安装

```ruby
pod 'Khala'
```

## 使用

1. **路由类**

   **定义:** 负责接收处理url的函数集合类.

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
   
   @objc(BModule)
   class AModule: NSObject {
    @objc func server1(_ info: [String: Any]) -> Int { ... }
    @objc func server2(_ info: [String: Any]) -> Int { ... }
   }
   ```

   > ps: 若非必要,无需提前注册路由类. 

2. **路由函数**

   **定义:** 负责处理具体的业务场景/功能.

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

4. **普通调用**

   适用于非异步场景.

   ```swift
   @objc(AModule) @objcMembers
   class AModule: NSObject {
    func server(_ info: [String: Any]) -> Int {
      return info["value"] as? Int ?? 0
    }
       
    func server2(_ info: [String: Any]) -> Int {
      guard let value = info["value"] as? String, let res = Int(value) else { return 0 }
      return res
    }
   }
   
   // 1. 保持参数类型
   let value = Khala(str: "kl://AModule/server", params: ["value": 46])?.call() as? Int
   print(value ?? "nil")
   
   /// Print
   // 46
   
   // 2. 不保持参数类型,(url中参数类型皆为String)
   let value = Khala(str: "kl://AModule/server2?value=64")?.call() as? Int
   print(value ?? "nil")
   
   /// Print
   // 64
   ```

5. **带block调用**

   适用于延时或者异步场景.

   **示例:**

   ```swift
   @objc(AModule) @objcMembers
   class AModule: NSObject {
    
     func forClosure(_ closure: KhalaClosure) {
       closure(["value": #function])
     }
     
     func forClosures(_ success: KhalaClosure, failure: KhalaClosure) {
       success(["success": #function])
       failure(["failure": #function])
     }
   
   }
   
   Khala(str: "kf://AModule/forClosure")?.call(block: { (item) in
   	print("forClosure:", item)
   })
       
   Khala(str: "kf://AModule/forClosures")?.call(blocks: [{ (item) in
   	print("forClosures block1:", item)
    },{ (item) in
   	print("forClosure block2:", item)
   }])
   
   /// Print
   // forClosure: ["value": "forClosure"]
   // forClosures block1: ["success": "forClosures(_:failure:)"]
   // forClosure block2: ["failure": "forClosures(_:failure:)"]
   ```

6. **特例调用**

   提供特定类型返回.详情查看: [**快捷函数**](https://linhay.github.io/Khala/Classes/Khala.html#/%E5%BF%AB%E6%8D%B7%E5%87%BD%E6%95%B02)

   ```swift
   @objc(AModule) @objcMembers
   class AModule: NSObject {
       func vc() -> UIViewController {
           return UIViewController()
       }
   }
   
   let value = Khala(str: "kl://AModule/vc?style=0")?.viewController
   // value is UIViewController
   ```

7. **通知调用**

   ```swift
   @objc(AModule) @objcMembers
   class AModule: NSObject {
       
      func vc() -> UIViewController {
           return UIViewController()
       }
       
      func doSomething(_ info: [String: Any]) {
       return description
       }
       
   }
   
   @objc(BModule) @objcMembers
   class BModule: NSObject {
       
      func vc() -> UIViewController {
   		return description
       }
       
      func doSomething(_ info: [String: Any]) {
           print("BModule: ",info["value"])
       }
       
   }
   
   // AModule 与 BModule 实例化,并缓存
   Khala(str: "kl://AModule")?.regist()
   Khala(str: "kl://BModule")?.regist()
       
   // 通知
   let value = KhalaNotify(str: "kl://doSomething?value=888")?.call()
   print(value ?? "")
   
   // Print
   // [<BModule: 0x60000242f230>, <AModule: 0x600002419d10>]
   ```

8. **重定向**

   - **使用**

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
     /// Print
     // <BModule: 0x6000026e2800>
     ```

   - **自定义重定向**

     1. 继承 `KhalaRewrite` 协议.

     2. 替换重定向模块

        ```swift
        Khala.rewrite = CustomRewrite()
        ```

9. **日志模块**

   日志模块默认为**关闭**状态,如需开启:

   ```swift
   Khala.isEnabledLog = true
   ```

   - **使用**(默认版本):

     文件路径: `/Documents/khala/logs/`

     文件内容:  日期 + 时间 + URL + 参数

     ```verilog
     2018-12-01 02:06:54  kl://SwiftClass/double?  {"test":"666"}
     2018-12-01 02:06:54  kl://SwiftClass/double  {"test":"666"}
     ```

   - **自定义日志**

     1. 继承 `KhalaHistory` 协议.

     2. 替换日志模块

        ```swift
        Khala.history = CustomHistory()
        ```

10. **提前注册路由类**

   该部分内容适合第三方服务模块,在 AppDelegate 中提前注册路由类.

   ```swift
   /// 全量注册 KhalaProtocol 路由类需要提前注册的路由类
   /// 需要遵从`KhalaProtocol`协议, 并在合适的时机调用.
   Khala.registWithKhalaProtocol()
   /// 单独注册
   Khala(str: "kl://AModule")?.regist()
   ```

   > [`KhalaProtocol`](https://linhay.github.io/Khala/Protocols.html#/c:@M@Khala@objc(pl)KhalaProtocol)协议

   **示例:**

   ```swift
   @objc(AModule) @objcMembers
   class AModule: NSObject, KhalaProtocol {
   	init(){
   	super.init()
   	//doSomething
       }
   }
   
   @objc(BModule) @objcMembers
   class BModule: NSObject, KhalaProtocol {
   	init(){
   	super.init()
   	//doSomething
       }
   }
   
   /// 全量注册 KhalaProtocol 路由类需要提前注册的路由类
   /// 需要遵从`KhalaProtocol`协议, 并在合适的时机调用.
   Khala.registWithKhalaProtocol()
   /// 单独注册
   Khala(str: "kl://AModule")?.regist()
   Khala(str: "kl://BModule")?.regist()
   ```

   > ps: 使用时启动更为推荐.

11. **其他**

   - 当url第一次定位至某一个路由类时,该类的实例将被缓存至 [**PseudoClass.cache**](https://linhay.github.io/Khala/Classes/PseudoClass.html#/c:@M@Khala@objc(cs)PseudoClass(cpy)cache) 中, 以提高二次查找性能.该属性权限为 `public`,开发者可以选择惬当的时机修改.
   - 某个路由类实例化时,该类中的函数列表将被缓存至 [**PseudoClass().methodLists**](https://linhay.github.io/Khala/Classes/PseudoClass.html#/c:@M@Khala@objc(cs)PseudoClass(py)methodLists)中, 以提高查找性能.该属性权限为 `public`,开发者可以选择惬当的时机修改.或移除位于 [**PseudoClass.cache**](https://linhay.github.io/Khala/Classes/PseudoClass.html#/c:@M@Khala@objc(cs)PseudoClass(cpy)cache) 中的路由类缓存.

12. **断言机制**

    为方便开发者使用,添加了部分场景下断言机制,示例:

    ```verilog
    khala.iOS Fatal error: [Khala] 未在[AModule]中匹配到函数[server], 请查看函数列表:
    0: init
    1: doSomething:
    2: vc
    ```

    **关闭断言**:

    ```swift
    Khala.isEnabledAssert = false
    ```

13. **扩展机制**

    ***khala***库中提供了一个空置的类[***KhalaStore***]用于盛放**路由函数**对应的本地函数.来简化本地调用复杂度的问题.

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

## 文档

- [**API Reference**](https://linhay.github.io/Khala/) - 更详细的参考api文档.
- [**iOS路由(Khala)设计**](https://www.linhey.com/2018/12/10/[2018%E5%B9%B4%E5%BA%A6%E6%80%BB%E7%BB%93]iOS%20%E8%B7%AF%E7%94%B1%E8%AE%BE%E8%AE%A1/) - khala的选型与模组化中的角色担当.

## 参考与致谢

- [**CTMediator**](https://github.com/casatwy/CTMediator): 由 [***Casa***](https://github.com/casatwy) 创建的 `Target-Action` 形式解耦路由.
- [**Routable**](https://github.com/linhay/Routable): *khala*的前身, 正式投入生产环境迭代2年.

## 作者

linhay, is.linhay@outlook.com

## License

Khala is available under the MIT license. See the LICENSE file for more info.
