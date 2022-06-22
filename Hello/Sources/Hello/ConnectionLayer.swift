//
//  ConnectionLayerViewModel.swift
//  TestDemo
//
//  Created by Kishan Singh on 12/06/22.
//

import Foundation
import Alamofire
//SendRequest(reqBody String, ServerAddress, Route, RequestHeaders string) -> return reponse string (Here reqBody, Request Header will be jsonString which needs to be converted to Json by IOS developer and Response needs to be converted from JSON to json string)
//CheckPing(reqBody, ServerAddress, Route, RequestHeaders) -> return response JsonString of format : {"ping":<int>} where ping is in milliseconds(ms).
//DownloadSpeedTest(reqBody, ServerAddress, Route, RequestHeaders) -> return response JsonString of format : {"downloadspeed":<int>} where download speed is in megabytes per second (MBps).
//UplaodSpeedTest(reqBody, ServerAddress, Route, RequestHeaders) -> return response JsonString of format :
//{"uploadspeed":<int>} where upload speed is in megabytes per second (MBps).

//CheckPing(reqBody, ServerAddress, Route, RequestHeaders) -> return response JsonString of format : {"ping":<int>} where ping is in milliseconds(ms).
//DownloadSpeedTest(reqBody, ServerAddress, Route, RequestHeaders) -> return response JsonString of format : {"downloadspeed":<float>} where download speed is in megabytes per second (MBps).
//UplaodSpeedTest(reqBody, ServerAddress, Route, RequestHeaders) -> return response JsonString of format :
//{"uploadspeed":<float>} where upload speed is in megabytes per second (MBps).


protocol ConnectionLayerViewModelProtocol {
    func sendRequest(serverAddress: String, endpoint: String, port: Int, reqBody: String, reqHeaders: String) -> String
}

class ConnectionLayerViewModel: ConnectionLayerViewModelProtocol {

    func sendRequest(serverAddress: String, endpoint: String, port: Int, reqBody: String, reqHeaders: String) -> String {
        let baseUrl = "https://" + serverAddress + ":" + String(port) + endpoint
        guard let urlString = URL(string: baseUrl) else { return "" }
        var request = URLRequest(url: urlString, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = HTTPMethod.post.rawValue

        let requestBody = Constants.convertToObject(from: reqBody)

        do {
            request = try JSONEncoding.default.encode(request, with: requestBody)
        } catch {
            print("it is throwing error")
        }

        request.headers = [:]

        if let requestHeader = Constants.convertToObject(from: reqHeaders) {
            for header in requestHeader {
               request.setValue(header.value, forHTTPHeaderField: header.key)
           }
        }
    
        var responseStr = ""
        NetworkManager.shared.apiRequest(urlRequest: request) { dataString, error in
            if let dataString = dataString {
                responseStr = dataString
            } else {
                responseStr = error ?? ""
            }
        }
        
        return responseStr
    }
}
