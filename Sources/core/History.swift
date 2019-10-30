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

/// When you want to customize the Logs module, you need to inherit the protocol.
@objc public
protocol KhalaHistory: NSObjectProtocol {
    var isEnabled: Bool { get set }
    func write(_ value: KhalaNode)
}

@objcMembers
class History: NSObject, KhalaHistory {
    
    var isEnabled: Bool = false
    private let dirPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? (NSHomeDirectory() + "/Documents/")) + "/khala/logs/"

    private let fileManager = FileManager.default

    private let dateFomtter: DateFormatter = {
        let item = DateFormatter()
        item.dateFormat = "yyyy-MM-dd"
        return item
    }()

    private let timeFomtter: DateFormatter = {
        let item = DateFormatter()
        item.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        return item
    }()

    private lazy var filehandle: FileHandle? = {
        let date = dateFomtter.string(from: Date())
        let filePath = dirPath + date + ".log"
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        return FileHandle(forWritingAtPath: filePath)
    }()

    override init() {
        super.init()
        // create directory
        if !fileManager.fileExists(atPath: dirPath) {
            print(dirPath)
            try? fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func format(_ value: KhalaNode) -> String {

        var str = "\n"
        str += timeFomtter.string(from: Date())
        str += " "
        str += value.url.absoluteString

        if !value.params.isEmpty, JSONSerialization.isValidJSONObject(value.params) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value.params, options: [])
                if let json = String(data: data, encoding: .utf8) {
                    str += " "
                    str += json
                }
            } catch {
                str += value.params.description
            }
        }

        return str
    }

    func write(_ value: KhalaNode) {
        guard isEnabled else { return }
        let str = format(value)
        filehandle?.seekToEndOfFile()
        if let data = str.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            filehandle?.write(data)
        } else {
            KhalaFailure.logWrite(message: str)
        }
    }

}
