//
//  Converters.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 08/08/24.
//

import Foundation
import CryptoKit

struct Converters {
    
    static func MD5(data: String)-> String{
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8)!)
        return hash.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    static func rightUrl(url :URL) -> URL {
        let http = url
        var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)
        comps?.scheme = "https"
        return (comps?.url!)!
    }
    
    static func httpsURL(url :URL) -> URL {
        let http = url
        var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)
        comps?.scheme = "https"
        return (comps?.url!)!
    }
    
}
