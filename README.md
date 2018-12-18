# Khala

[![CI Status](https://img.shields.io/travis/linhay/Khala.svg?style=flat)](https://travis-ci.org/linhay/Khala)
[![Version](https://img.shields.io/cocoapods/v/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![License](https://img.shields.io/cocoapods/l/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)
[![Platform](https://img.shields.io/cocoapods/p/Khala.svg?style=flat)](https://cocoapods.org/pods/Khala)



![](https://s.linhey.com/khala.png)

Swift 路由和模块通信解耦工具和规范。 可以让模块间无耦合的调用服务、页面跳转。

> English Introduction

## 安装

```ruby
pod 'Khala'
```

## 使用





## 调用

1. **普通调用**

   ```swift
   let value = Khala(str: "kl://AModule/server?info=ok")?.call()
   // value is Any?
   ```

2. **带block调用**

   - **单个block**
   - **多个block**

3. **特例调用**

   ```swift
   let value = Khala(str: "kl://AModule/vc?style=0")?.viewController
   // value is UIViewController or NSViewController
   ```

4. **通知调用**

   ```swift
   let value = KhalaNotify(str: "kl://double?test=666")?.call()
   // value is [Any]
   ```

5. **Rewrite**

   - **使用**
   - **自定义**

6. **History**

   - **使用**
   - **自定义**

7. **PseudoClass**

   - **PseudoClass.cache**

     路由类初始化后会被添加至该属性中缓存,以减少查找与实例化这部分性能.

     你可以使用该属性**释放指定或全部路由类**.

   - **PseudoClass().instance**

     路由类实例.

   - **PseudoClass().methodLists**

     路由类实例中函数列表, 路由函数查询只会查询此列表中的函数.

     ​

## Useage

- [API Reference](https://linhay.github.io/Khala/) - Lastly, please remember to read the full whenever you may need a more detailed reference. 

## Author

linhay, is.linhay@outlook.com

## License

Khala is available under the MIT license. See the LICENSE file for more info.
