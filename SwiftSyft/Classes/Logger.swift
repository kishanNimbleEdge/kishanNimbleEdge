//
//  Logger.swift
//  OpenMinedSwiftSyft
//
//  Created by Kishan Singh on 30/06/22.
//

import Foundation

struct LogConfig: Decodable {
    var APIKey: String = "7db8c072ded281245008b1d2689e4cfd"
    var url: URL = URL(string: "https://http-intake.logs.datadoghq.com/api/v2/logs")!
    var source: String = "iOS"
    var tags: String = "env:oyopoc,version:1.0"
    var service: String = "mobilesdk"
    var dateFormat: String = "yyyy-MM-dd hh:mm:ss"
}

public class Logger {
    static let dateFormatter = DateFormatter()
    static var config: LogConfig = LogConfig()

    public static let shared = Logger()
    private init () {
        Logger.config = LogConfig()
        Logger.dateFormatter.dateFormat = Logger.config.dateFormat
    }

    private func sendLog(message: String, level: String, hostname: String) {
        var request = URLRequest(url: Logger.config.url)
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue(Logger.config.APIKey, forHTTPHeaderField:"DD-API-KEY")
        request.httpMethod = "POST"
        let body: [String: String] = [
            "ddsource": Logger.config.source,
            "ddtags": Logger.config.tags,
            "hostname": hostname,
            "message": message,
            "service": Logger.config.service,
            "status": level
        ]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonBody

        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
//            if let data = data {
//                print("HTTP Request success \(data)")
//            } else if let error = error {
//                print("HTTP Request Failed \(error)")
//            }
        }

        task.resume()
    }

    public func info(message: String, deviceId: String, file: String = #file, line: Int = #line, col: Int = #column, funcName: String = #function) {
        let msg = "INFO: \(Logger.dateFormatter.string(from: Date())) [\(Logger.extractFileName(filePath: file)) -> \(funcName): line \(line), column \(col)]: \(message)"
        sendLog(message: msg, level: "INFO", hostname: deviceId)
    }

    public func error(message: String, deviceId: String, file: String = #file, line: Int = #line, col: Int = #column, funcName: String = #function) {
        let msg = "ERROR: \(Logger.dateFormatter.string(from: Date())) [\(Logger.extractFileName(filePath: file)) -> \(funcName): line \(line), column \(col)]: \(message)"
        sendLog(message: msg, level: "ERROR", hostname: deviceId)
    }

    public func fatal(message: String, deviceId: String, file: String = #file, line: Int = #line, col: Int = #column, funcName: String = #function) {
        let msg = "FATAL: \(Logger.dateFormatter.string(from: Date())) [\(Logger.extractFileName(filePath: file)) -> \(funcName): line \(line), column \(col)]: \(message)"
        sendLog(message: msg, level: "FATAL", hostname: deviceId)
    }

    public func warn(message: String, deviceId: String, file: String = #file, line: Int = #line, col: Int = #column, funcName: String = #function) {
        let msg = "WARN: \(Logger.dateFormatter.string(from: Date())) [\(Logger.extractFileName(filePath: file)) -> \(funcName): line \(line), column \(col)]: \(message)"
        sendLog(message: msg, level: "WARN", hostname: deviceId)
    }

    public func debug(message: String, deviceId: String, file: String = #file, line: Int = #line, col: Int = #column, funcName: String = #function) {
        let msg = "DEBUG: \(Logger.dateFormatter.string(from: Date())) [\(Logger.extractFileName(filePath: file)) -> \(funcName): line \(line), column \(col)]: \(message)"
        sendLog(message: msg, level: "DEBUG", hostname: deviceId)
    }

    private class func extractFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
