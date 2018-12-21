# [Khala](https://github.com/linhay/Khala)

![](https://s.linhey.com/Khala.png)

[![CI Status](https://api.travis-ci.com/linhay/Khala.svg)](https://travis-ci.org/linhay/Khala)
[![Version](https://img.shields.io/cocoapods/v/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![License](https://img.shields.io/cocoapods/l/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![Platform](https://img.shields.io/cocoapods/p/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)


Swift 路由和模块通信解耦工具和规范。 可以让模块间无耦合的调用服务、页面跳转。

> [**中文介绍**](README.md)

## Features

- [x] Support for component development based on cocopods.
- [x] No need to register the URL, use runtime to implement the `target-action` form call.
- [x] Built-in URL Rewrite module.
- [x] Built-in log module.
- [x] Support module customization.
- [x] Built-in assertions and can switch languages.
- [x] Priority support swift.

## Requirements

- **iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+**

- **Swift 4.x**

## Installation

### CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```shell
$ gem install cocoapods
```

> CocoaPods 1.1+ is required.

To integrate Khala into your Xcode project using CocoaPods, specify it in your `Podfile`: 

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Khala'
end
```

Then, run the following command:

```shell
$ pod install
```

## definition

> Some content can not be defined exactly, I took the liberty to define the following terms.

1. **Routing class:**  This class is responsible for receiving routing events..
2. **Routing function:** The function responsible for receiving routing events in the routing class.

## Usage

1. **URL**

   In Khala, the most primitive URL structure is:

   ```verilog
   scheme://[route class]/[route function]?key1=value1&key2=value2
   ```

   > But you can use rewrite module to write custom rules to implement complex URL structures, and access control.

2. **First we define two Routing files, respectively, and packed into two pod library.**

   > This part of the content can be viewed in the sample project

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

3. **Execute the routing function via the URL:** [**Khala**](https://linhay.github.io/Khala/Classes/Khala.html)

   - Ordinary call: 

     ```swift
     // 2. 不保持参数类型,(url中参数类型皆为String)
     let value = Khala(str: "kl://AModule/server2?value=64")?.call() as? Int
     print(value ?? "nil")
     /// Print: 64
     ```

   - Async call:

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

   - **UIKit/AppKit Extension**:

     ```swift
     let vc = Khala(str: "kl://BModule/vc?style=0")?.viewController
     ```

4. **Routing notification **[**KhalaNotify**](https://linhay.github.io/Khala/Classes/KhalaNotify.html)

   This type can be used to execute functions of the same name in multiple cached routing classes.

   ```swift
   // Cache AModule and BModule routing classes.
   Khala(str: "kl://AModule")?.regist()
   Khala(str: "kl://BModule")?.regist()
       
   // Executive notice
   let value = KhalaNotify(str: "kl://doSomething?value=888")?.call()
   print(value ?? "")
   
   // Print: [<BModule: 0x60000242f230>, <AModule: 0x600002419d10>]
   ```

   > Notifications can only be sent to routing classes that have been cached. Cache location:[**PseudoClass.cache**](https://linhay.github.io/Khala/Classes/PseudoClass.html#/c:@M@Khala@objc(cs)PseudoClass(cpy)cache)

5. **Registered route**

   In  [**Khala**](https://linhay.github.io/Khala/Classes/Khala.html#/c:@CM@Khala@objc(cs)Khala(im)register) I provided the following interface to abstract  [**PseudoClass.cache**](https://linhay.github.io/Khala/Classes/PseudoClass.html#/c:@M@Khala@objc(cs)PseudoClass(cpy)cache):

   ```swift
   // Register route class, Equivalent to Khala(str: "kl://AModule/doSomething")
   func register() -> Bool
   // Unregister routing class, Equivalent to PseudoClass.cache["AModule"] = nil
   func unregister() -> Bool
   // Cancel all registered routing classes, Equivalent to PseudoClass.cache.removeAll()
   func unregisterAll() -> Bool
   // Batch registration of routing classes that comply with the KhalaProtocol protocol
   Khala.registWithKhalaProtocol()
   ```

   > Personal advice, please try to avoid using.
   >
   > [**KhalaProtocol**](https://linhay.github.io/Khala/Protocols.html#/c:@M@Khala@objc(pl)KhalaProtocol)

6. **Rewrite Module:** [**KhalaRewrite**](https://linhay.github.io/Khala/Protocols/KhalaRewrite.html)

   This part is especially important if the developer needs a custom route resolution rule or a redirect route function.

   1. Write the rules:

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

   2. Add rules:

      ```swift
      Khala.rewrite.filters.append(filter)
      ```

   3. Request call:

      ```swift
      let value = Khala(str: "kl://AModule/doSomething")?.call()
      print(value ?? "nil")
      /// Print: <BModule: 0x6000026e2800>
      ```

7. **Log module:** [**KhalaHistory**](https://linhay.github.io/Khala/Protocols/KhalaHistory.html)

   Each url request will be logged to the log file and sent to the developer at the appropriate time.

   1. Open log (default false)

      ```swift
      Khala.isEnabledLog = true
      // or 
      Khala.history.isEnabled = true
      ```

   2. Log file path: `/Documents/khala/logs/`

   3. File contents: Date + Time + URL + Parameters

      ```verilog
      2018-12-01 02:06:54  kl://SwiftClass/double?  {"test":"666"}
      2018-12-01 02:06:54  kl://SwiftClass/double  {"test":"666"}
      ```

8. **Extension mechanism:**  [**KhalaStore**](https://linhay.github.io/Khala/Classes.html#/c:@M@Khala@objc(cs)KhalaStore)

   In ***khala***, a vacant class ***KhalaStore*** is proposed, which can be used to place the mapping function of the routing function, thus simplifying the local call complexity.

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

   > ps: KhalaStore Extension files are recommended to be placed in the same cocoapod library.

9. **Assertion mechanism**

   For the convenience of developers, the assertion mechanism in some scenarios has been added, examples:

   ```verilog
   khala.iOS Fatal error: 
   [Khala] If there is no match to the route function [server] in the route class[AModule], please refer to the list of functions of this class: 
   0: init
   1: doSomething:
   2: vc
   ```

   Turn off assertions (default true):

   ```swift
   Khala.isEnabledAssert = false
   ```

10. **Cache mechanism:** [**PseudoClass.cache**](https://linhay.github.io/Khala/Classes/PseudoClass.html#/c:@M@Khala@objc(cs)PseudoClass(cpy)cache)

  - When the route first calls the registration route class, the route class will be cached in ***PseudoClass.cache*** to improve the secondary lookup performance.
  - When the route class is instantiated, the list of functions in the route class will be cached in ***PseudoClass().methodLists*** to improve lookup performance.

## Precautions

1. **Routing class**

   **limit:**

    1. The routing class must inherit from `NSObject`

    2. Need to add `@objc(class_name) ` to prevent the compiler from removing the class.

       > The compiler will check for classes that are not called in the swift file at compile time and remove them. (>= swift 3.0)

   **Example:**

   ```swift
   // recommend
   @objc(AModule) @objcMembers
   class AModule: NSObject {
    func server1(_ info: [String: Any]) -> Int { ... }
    func server2(_ info: [String: Any]) -> Int { ... }
   }
   
   // or
   @objc(BModule)
   class AModule: NSObject {
    @objc func server1(_ info: [String: Any]) -> Int { ... }
    @objc func server2(_ info: [String: Any]) -> Int { ... }
   }
   ```

2. **Routing function**

   **limit:**

    1. **Function overloading is not supported.** For example:

       ```swift
       @objc(AModule) @objcMembers
       class AModule: NSObject {
        func server(_ info: [String: Any]) -> Int { ... }
        func server(_ info: [String: Any], closure: KhalaClosure) -> Int { ... }
       }
       ```

       > Reason: When khala adopts the cache routing function, the function name mapping is adopted.

       2. Recommended routing function of the first parameter is anonymous and easy to read.

       3. Parameter format

       - Single: `[AnyHashable: Any]`, no order requirements

       - Multiple: `KhalaClosure`, with order requirements

         ```swift
         typealias KhalaClosure = @convention(block) (_ useInfo: [String: Any]) -> Void
         ```

       **Example:**

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

       > reason:
       >
       >   `block` is a structure type, and it is impossible to abstract the base class or protocol.
       >
       > `[String: Any]` will insert the parameter list in `[KhalaClosure]`.
       >
       > Ps: The number of callers `KhalaClosure` needs to be more or flatter than the routing function. Otherwise the assertion will be triggered.

3. ***Khala*** Initialization function

   - The parameters in `params` will be kept in the type passed, such as the need to pass objects such as `UIImage`.

   ```swift
   public class Khala: NSObject {
   	public init(url: URL, params: [AnyHashable: Any] = [:]) { ... }
   	public init?(str: String, params: [AnyHashable: Any] = [:]) { ... } 
   }
   ```

## Advanced usage

1. **Custom Rewrite module**

   1. Inherit the `KhalaRewrite` protocol.

   2. Replace Rewrite module

      ```
      Khala.rewrite = CustomRewrite()
      ```

2. **Custom log module**

   1. Inherit the `KhalaHistory` protocol.

   2. Replace log module

      ```swift
      Khala.history = CustomHistory()
      ```


## TODO

- [ ] Improve Objective-C calls
- [ ] Perfect demo example.
- [ ] The log module reads and writes with *mmap*(Some files are not written to the file when the program crashes).
- [ ] Improve English notes and documentation.

## Documents

- [**API Reference**](https://linhay.github.io/Khala/) - please remember to read the full whenever you may need a more detailed reference.

## Reference and thanks

- [**CTMediator**](https://github.com/casatwy/CTMediator): A routing framework created by [***Casa***](https://github.com/casatwy).
- [**Routable**](https://github.com/linhay/Routable): The predecessor of [**khala**](https://github.com/linhay/Khala), officially put into production environment iteration for 2 years.
- [**Starcraft **](https://sc2.blizzard.cn/home)

## Author

linhay, is.linhay@outlook.com

## License

Khala is available under the MIT license. See the LICENSE file for more info.
