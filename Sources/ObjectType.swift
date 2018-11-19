//
//  ObjectType.swift
//  DarkTemplar
//
//  Created by linhey on 2018/11/19.
//

import Cocoa

enum ObjectType: String {
  case void     = "v"   //void类型   v
  case sel      = ":"   //selector  :
  case object   = "@"   //对象类型   "@"
  case block    = "@?"
  case double   = "d"   //double类型 d
  case int      = "i"   //int类型    i
  case bool     = "B"   //C++中的bool或者C99中的_Bool B
  case longlong = "q"   //long long类型 q
  case point    = "^"   //  ^
  case unknown  = "."
  case char     = "c"   //char      c
  case short    = "s"   //short     s
  case long     = "l"   //long      l
  case float    = "f"   //float     f
  case `class`  = "#"   //class     #
  case unsignedChar  = "C"    //unsigned char    C
  case unsignedInt   = "I"    //unsigned int     I
  case unsignedShort = "S"    //unsigned short   S
  case unsignedLong  = "L"    //unsigned long    L
  case unsignedLongLong = "Q" //unsigned short   Q
  //  case char*    = "*" //char*     *
  //  case array    =     //[array type]
  //  case `struct` =     //{name=type…}
  //  case union    =     //(name=type…)
  //  case bnum     =     //A bit field of num bits
  
  init(char: UnsafePointer<CChar>) {
    guard let str = String(utf8String: char) else {
      self = .unknown
      return
    }
    self = ObjectType(rawValue: str) ?? .unknown
  }
  
}
