//
//  DetailedCharactersModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//


struct DetailedCharactersModel: Codable{
    var data: SubModel
}
struct SubModel: Codable {
    var results: [ComicDetails]
}
struct ComicDetails: Codable{
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: [String: String]
    var urls: [[String:String]]
    var creators: CreatorsForCharacters
}
struct CreatorsForCharacters: Codable, Hashable{
    var items: [CreatorsListForCharacters]
}
struct CreatorsListForCharacters: Identifiable, Codable, Hashable{
    var id: Int?
    var name: String
    var role: String
}
