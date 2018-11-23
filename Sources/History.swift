//
//  Historiographer.swift
//  BLFoundation
//
//  Created by linhey on 2018/11/22.
//

import Cocoa
import Darwin

class History: NSObject {
  
  let dirPath = NSHomeDirectory() + "/Documents/khala/logs/"
  let fileManager = FileManager.default
  lazy var filehandle: FileHandle? = openFile()
  
  override init() {
    super.init()
    // create directory
    if !fileManager.fileExists(atPath: dirPath) {
      try? fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
  func openFile() -> FileHandle? {
    let date = Date().description[...String.Index(encodedOffset: 9)]
    let filePath = dirPath + date + ".log"
    if !fileManager.fileExists(atPath: filePath) {
      fileManager.createFile(atPath:filePath, contents: nil, attributes: nil)
    }
    
    let handle = FileHandle(forWritingAtPath: filePath)
    handle?.seekToEndOfFile()
    return handle
  }
  
  func write(_ value: URLValue) {
    var str = "\n"
    str += Date().description[...String.Index(encodedOffset: 18)]
    str += "  "
    str += value.url.absoluteString
    
    if value.params.isEmpty || JSONSerialization.isValidJSONObject(value.params) {
      do{
        let data = try JSONSerialization.data(withJSONObject: value.params, options: [])
        if let json = String(data: data, encoding: .utf8) {
          str += "  "
          str += json
        }
      }catch{
        Khala.failure("[Khala] params parse fail: \(error.localizedDescription)")
      }
    }
    
    if let data = str.data(using: String.Encoding.utf8, allowLossyConversion: true) {
      filehandle?.write(data)
    }else{
      Khala.failure("[Khala] log redirect data fail: \(str)")
    }
  }
  
  
//  func log(with mmap: Bool) {
//    let manager = FileManager.default
//
//    let MEM_SIZE:Int = Int(getpagesize())
//    let filePath = Bundle.main.path(forResource: "data", ofType: "txt")!
//
//    // let filePath = NSHomeDirectory() + "/Documents/khala/logs/2018-11-22.log"
//    let fhIn = FileHandle(forReadingAtPath: filePath)!
//    ftruncate(fhIn.fileDescriptor, off_t(1024))
//    sync()
//    // 获取文件大小
//    let fileSize = fhIn.seekToEndOfFile()
//
//    var part = mmap(UnsafeMutableRawPointer(bitPattern: 0),
//                    Int(MEM_SIZE),
//                    PROT_READ,
//                    MAP_SHARED,
//                    fhIn.fileDescriptor,
//                    off_t(0 * MEM_SIZE))!
//
//
//    if part == MAP_FAILED {
//      assertionFailure("[Khala] Create mmap failed: \(errno)")
//      return
//    }
//    let buf = malloc(Int(MEM_SIZE))
//    memcpy(buf, part, Int(MEM_SIZE))
//    var data = Data(bytes: buf!, count: Int(MEM_SIZE))
//    print(String.init(data: data, encoding: String.Encoding.utf8))
//    munmap(part,MEM_SIZE)
//  }
  
  
}
