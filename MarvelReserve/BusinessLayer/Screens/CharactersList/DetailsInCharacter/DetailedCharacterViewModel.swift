//
//  DetailedCharacterViewModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 08/08/24.
//

import Foundation
import Combine
import CryptoKit
import WebKit
import SwiftUI

class ApiForCharactersComic: ObservableObject {
    @Published var comics: ComicDetails?
    @Published var isLoading = true
    
    func getComicForCharacter(_ com: Items) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = Converters.MD5(data: "\(ts)\(Constants.apiPrivateKey)\(Constants.apiPublicKey)")
        lazy var reserveURL = URL(string: (""))
        let neededURL = Converters.httpsURL(url: URL(string:(com.resourceURI ?? "")+"?ts=\(ts)&apikey=\(Constants.apiPublicKey)&hash=\(hash)")!)
        let session = URLSession(configuration: .default)
        session.dataTask(with:  neededURL) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            do{
                let comicInfo = try JSONDecoder().decode(DetailedCharactersModel.self, from: data)
                DispatchQueue.main.async{ [self] in
                    comics = comicInfo.data.results.first
                    isLoading = false
                    
                    print("URLRequest: Success")
                }
            } catch(let err) {
                print("URLRequest Error:", err)
            }
            
        }.resume()
    }
}
