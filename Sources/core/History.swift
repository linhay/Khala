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
import Darwin


/// When you want to customize the Logs module, you need to inherit the protocol.
@objc public
protocol KhalaHistory: NSObjectProtocol {
    var isEnabled: Bool { set get }
    func write(_ value: KhalaNode)
}

@objcMembers
class History: NSObject, KhalaHistory {
    
    var isEnabled: Bool = false
    private let dirPath = NSHomeDirectory() + "/Documents/khala/logs/"
    private let fileManager = FileManager.default
    private lazy var filehandle: FileHandle? = openFile()
    
    override init() {
        super.init()
        // create directory
        if !fileManager.fileExists(atPath: dirPath) {
            try? fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func openFile() -> FileHandle? {
        let dateDesc = Date().description
        let date = dateDesc.dropLast(dateDesc.count - 9)
        let filePath = dirPath + date + ".log"
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath:filePath, contents: nil, attributes: nil)
        }
        
        let handle = FileHandle(forWritingAtPath: filePath)
        handle?.seekToEndOfFile()
        return handle
    }
    
    func write(_ value: KhalaNode) {
        guard isEnabled else { return }
        var str = "\n"
        let dateDesc = Date().description
        str += dateDesc.dropLast(dateDesc.count - 18)
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
                str += value.params.description
            }
        }
        
        if let data = str.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            filehandle?.write(data)
        }else{
            KhalaFailure.logWrite(message: str)
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
