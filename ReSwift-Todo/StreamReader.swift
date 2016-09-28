import Foundation

/// Sequentially read from URL.
/// - via: Martin R <http://stackoverflow.com/a/24648951/1460929>
class StreamReader  {

    let encoding: String.Encoding
    let chunkSize: Int
    var fileHandle: FileHandle!
    var buffer: Data
    let delimData: Data
    var atEof: Bool = false

    init(url: URL, delimiter: String = String.newline, encoding: String.Encoding = .utf8, chunkSize: Int = 4096) throws {

        guard let delimData = delimiter.data(using: encoding)
            else { throw ImportError.cannotUseDelimiter(delimiter) }

        self.fileHandle = try FileHandle(forReadingFrom: url)
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
    }

    deinit {
        self.close()
    }

    func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")

        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }

    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }

    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : Sequence {
    
    func makeIterator() -> AnyIterator<String> {
        
        return AnyIterator {
            return self.nextLine()
        }
    }
}
