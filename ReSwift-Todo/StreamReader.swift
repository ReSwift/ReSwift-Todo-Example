//
//  StreamReader.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 07/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

/// Sequentially read from URL.
/// - via: Martin R <http://stackoverflow.com/a/24648951/1460929>
class StreamReader  {

    let encoding : UInt
    let chunkSize : Int

    var fileHandle : NSFileHandle!
    let buffer : NSMutableData!
    let delimData : NSData!
    var atEof : Bool = false

    init(URL: NSURL, delimiter: String = String.newline, encoding: UInt = NSUTF8StringEncoding, chunkSize: Int = 4096) throws {

        self.chunkSize = chunkSize
        self.encoding = encoding

        do {
            self.fileHandle = try NSFileHandle(forReadingFromURL: URL)
        } catch {

            self.delimData = nil
            self.buffer = nil
            throw error
        }

        if let delimData = delimiter.dataUsingEncoding(encoding),
            buffer = NSMutableData(capacity: chunkSize) {

            self.delimData = delimData
            self.buffer = buffer
        } else {

            self.delimData = nil
            self.buffer = nil

            throw ImportError.cannotPrepareStream
        }
    }

    deinit {
        self.close()
    }

    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")

        if atEof {
            return nil
        }

        // Read data chunks from file until a line delimiter is found:
        var range = buffer.rangeOfData(delimData, options: [], range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let tmpData = fileHandle.readDataOfLength(chunkSize)
            if tmpData.length == 0 {
                // EOF or read error.
                atEof = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: buffer, encoding: encoding)

                    buffer.length = 0
                    return line as String?
                }
                // No more lines.
                return nil
            }
            buffer.appendData(tmpData)
            range = buffer.rangeOfData(delimData, options: [], range: NSMakeRange(0, buffer.length))
        }

        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdataWithRange(NSMakeRange(0, range.location)),
                            encoding: encoding)
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)

        return line as String?
    }

    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seekToFileOffset(0)
        buffer.length = 0
        atEof = false
    }

    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : SequenceType {
    
    func generate() -> AnyGenerator<String> {
        
        return AnyGenerator {
            return self.nextLine()
        }
    }
}
