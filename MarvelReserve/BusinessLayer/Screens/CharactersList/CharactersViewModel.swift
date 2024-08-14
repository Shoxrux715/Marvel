//
//  CharactersViewModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import Foundation
import Combine
import CryptoKit
import WebKit
import SwiftUI

class CharacterApiGetter: ObservableObject {
    
    @Published var charactersNavigate: Bool = false
    @Published var tappedCharacter: Character?
    
    @Published var charactersList: [Character]? = []
    @Published var searchQuery = ""
    @Published var isLoading = false
    
    var searchCancellable: AnyCancellable? = nil
    
    init() {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink(receiveValue: { [self] str in
                if str == "" {
                    self.charactersList = nil
                    isLoading = false
                } else {
                    isLoading = true
                    self.getCharactersList()
                }
            })
    }
    
    func setSelectedCharacter(_ character: Character) {
        charactersNavigate = true
        tappedCharacter = character
    }
    
    func getCharactersList() {
        let ts = String(Date().timeIntervalSince1970)
        let hash = Converters.MD5(data: "\(ts)\(Constants.apiPrivateKey)\(Constants.apiPublicKey)")
        let searchCharacter = searchQuery.replacingOccurrences(of: "", with: "%20")
        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(searchCharacter)&ts=\(ts)&apikey=\(Constants.apiPublicKey)&hash=\(hash)"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            do{
                let characters = try JSONDecoder().decode(CharacterModel.self, from: data)
                DispatchQueue.main.async{[self] in
                    charactersList = characters.data.results
                    print("URLRequest: Success")
                    isLoading = false
                }
                
            } catch(let err) {
                print("URLRequest Error:", err)
            }
        }.resume()
    }
    
    func refreshCharactersList(){
        charactersList?.removeAll()
    }
    
    func loadCharactersList() {
        Task(priority: .medium) {
            getCharactersList()
        }
    }
    
}


