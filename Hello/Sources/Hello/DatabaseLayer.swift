//
//  File.swift
//  
//
//  Created by Kishan Singh on 20/06/22.
//
//save(inputByteStream, filePath) -> returns filePath where the file is finally stored(a string)
//retrieve_data(filePath) -> returns byteStream containing the content of file
//deleteData(filePath) -> returns status(true/false)

import Foundation

protocol DataBaseManagerProtocol {
    func save(inputByteStream: String, filePath: String) -> String
    func retrieveData(filePath: String) -> String
    func deleteData(filePath: String) -> Bool
}
class DataBaseManager: DataBaseManagerProtocol {
    func save(inputByteStream: String, filePath: String) -> String {
        let s = "12345"
        let d = s.data(using: String.Encoding.ascii)!
        let path = ("~/Desktop/test.txt" as NSString).expandingTildeInPath
        if let fh = FileHandle(forWritingAtPath: path) {
            fh.seekToEndOfFile()
            fh.write(d)
            fh.closeFile()
        }
        
        return path
    }
    func retrieveData(filePath: String) -> String {
        return "retrieve Data"
    }
    func deleteData(filePath: String) -> Bool {
        return false
    }
}
