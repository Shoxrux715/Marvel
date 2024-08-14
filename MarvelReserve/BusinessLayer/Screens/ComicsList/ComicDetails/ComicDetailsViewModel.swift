//
//  ComicDetailsViewModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import Foundation
import Combine
import CryptoKit
import WebKit
import SwiftUI

class ApiForCharacterList: ObservableObject {
    
    @Published var character: CharacterDetails?
    
    @Published var isLoading = true
    
    @Published var thumbnail: [String: String]?
    
    func getCharactersListInComic(_ char: ItemsCharacters) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = Converters.MD5(data: "\(ts)\(Constants.apiPrivateKey)\(Constants.apiPublicKey)")
        lazy var reserveURL = URL(string: (""))
        let neededURL = Converters.convertToSecureURL(url: URL(string:(char.resourceURI ?? "")+"?ts=\(ts)&apikey=\(Constants.apiPublicKey)&hash=\(hash)")!)
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
                let charInfo = try JSONDecoder().decode(DetailedComicModel.self, from: data)
                DispatchQueue.main.async{ [self] in
                    character = charInfo.data.results.first
                    thumbnail = charInfo.data.results.first?.thumbnail
                    isLoading = false
                    print("URLRequest: Success")
                }
            } catch(let err) {
                print("URLRequest Error:", err)
            }
        }.resume()
    }
}
