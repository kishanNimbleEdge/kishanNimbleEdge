//
//  File.swift
//  
//
//  Created by Kishan Singh on 20/06/22.
//

import Foundation
import SystemConfiguration

protocol NetworkLayerProtocol {
    func internetStatus() -> Bool
    func enableNotRestricted() -> Bool
    func disableNotRestricted() -> Bool
    func enableMeteredData() -> Bool
    func disableMeteredData() -> Bool
    func checkIfExists(filePath: String) -> Bool
}
class NetworkLayer: NetworkLayerProtocol {
    func internetStatus() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    func enableNotRestricted() -> Bool {
        return true
    }
    
    func disableNotRestricted() -> Bool {
        return true
    }
    
    func enableMeteredData() -> Bool {
        return true
    }
    
    func disableMeteredData() -> Bool {
        return true
    }
    
    func checkIfExists(filePath: String) -> Bool {
        return true
    }
    
}
