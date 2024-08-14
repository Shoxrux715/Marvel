//
//  Extracters.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import Foundation

struct Extracters {
    static func extractImageURL(data: [String: String]) -> URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        let http = URL(string: "\(path).\(ext)")!
        var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)
        comps?.scheme = "https"
        return (comps?.url!)!
    }
    
    static func extractURL(data: [String: String]) -> URL{
        let url = data["url"] ?? ""
        return URL(string: url)!
    }
    
    static func extractTypeURL(data: [String: String]) -> String{
        let type = data["type"] ?? ""
        return type.capitalized
    }
}
