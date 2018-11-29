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

enum ObjectType: String,Hashable {
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
