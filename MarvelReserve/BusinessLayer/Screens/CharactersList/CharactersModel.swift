//
//  CharactersModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//


struct CharacterModel: Codable{
    var data: CharacterSubModel
}
struct CharacterSubModel: Codable{
    var count: Int
    var results: [Character]
    
}
struct Character: Codable, Identifiable{
    var id: Int
    var name: String
    var description: String
    var thumbnail: [String: String]
    var comics: CharacterInComicsList
    var urls: [[String: String]]
}
struct CharacterInComicsList: Codable{
    var available: Int?
    var collectionURI: String?
    var items: [Items]
}
struct Items: Codable,Identifiable, Hashable{
    var id: Int?
    var resourceURI: String?
    var name: String?
}
