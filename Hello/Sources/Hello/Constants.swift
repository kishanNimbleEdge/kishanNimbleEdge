//
//  Constants.swift
//  TestDemo
//
//  Created by Kishan Singh on 12/06/22.
//

import Foundation
import Alamofire
struct Constants {
    static func convertToObject(from jsonStr: String) -> Dictionary<String,String>? {
        let data = jsonStr.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,String>
            {
                print("requested json : ", jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return nil
            }
        } catch  {
            return nil
        }
    }
}


