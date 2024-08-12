//
//  DetailedComicModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 14/06/24.
//

struct DetailedComicModel: Codable{
    var data: SubModelForCharacter
}
struct SubModelForCharacter: Codable {
    var results: [CharacterDetails]
}
struct CharacterDetails: Codable{
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: [String: String]
    var urls: [[String:String]]
}



struct DetailedModel: Codable{
    var data: ModelForCharacter
}
struct ModelForCharacter: Codable {
    var results: [CharacterDet]
}
struct CharacterDet: Codable{
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: [String: String]
    var urls: [[String:String]]
}
