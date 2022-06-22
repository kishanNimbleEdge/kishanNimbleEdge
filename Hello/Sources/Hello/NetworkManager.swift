//
//  NetworkManager.swift
//  TestDemo
//
//  Created by Kishan Singh on 12/06/22.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    private init () {}
    
    func apiRequest(urlRequest: URLRequest, completionHandler: @escaping (String?, String?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            if let response = response as? HTTPURLResponse {
                print("data coming from api : \(data)")
                let errorMessage = "Error \(response.statusCode) OCCURED"
                self.handlingResponseStatusCode(statusCode: response.statusCode, response: response, errorMessage: errorMessage, data: data) { data, response, error in
                    if let response = data {
                        do{
                            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any]
                            if let json = json {
                                let str = self.dataParsing(json)
                                completionHandler(str, error)
                            } else {
                                completionHandler(nil, error)
                            }
                        } catch{
                            completionHandler(nil, "")
                        }
                    }
                    completionHandler(nil, error)
                }
            }
        }
            task.resume()
    }
}
extension NetworkManager {
    
    private func handlingResponseStatusCode(statusCode: Int, response: HTTPURLResponse, errorMessage: String, data: Data?, completionHandler: @escaping (Data?, URLResponse?, String?) -> Void) {
        switch statusCode {
        case 200, 204:
            completionHandler(data, response, nil)
        case 400:
            completionHandler(data, response, "Something Went wrong ")
        case 500:
             completionHandler(data, response, "Internal server error")
        default:
            completionHandler(nil, response, "ERROR")
        }
    }
    
    private func dataParsing(_ data: [String:Any]) -> String {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: data,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            print("\(theJSONText!)")
            return theJSONText ?? ""
        }
        return ""
    }
}
