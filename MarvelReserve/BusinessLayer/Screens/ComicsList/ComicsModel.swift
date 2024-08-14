//
//  ComicsModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import Foundation

struct ComicsModel: Codable {
    var data: ComicsSubModel
}

struct ComicsSubModel: Codable {
    let results: [Comic]
}

struct Comic: Identifiable, Codable, Hashable {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: [String: String]
    var urls: [[String:String]]
    var prices: [PriceList]
    var creators: CreatorsInfo
    var characters: CharactersListInComics
}
struct CharactersListInComics: Codable, Hashable{
    var available: Int?
    var items: [ItemsCharacters]
}
struct ItemsCharacters: Codable, Identifiable, Hashable{
    var id: Int?
    var resourceURI: String?
    var name: String?
}
struct CreatorsInfo: Codable, Hashable{
    var items: [CreatorsList]
}
struct CreatorsList: Identifiable, Codable, Hashable{
    var id: Int?
    var name: String
    var role: String
}
struct PriceList: Codable, Hashable {
    var type: String
    var price: Double
}

//class ComicModel {
//    
//    var model: Comic
//    
//    init(model: Comic) {
//        self.model = model
//    }
//    
//    func extractComicImageURL() -> URL? {
//        return model["data"] as URL
//    }
//}




#warning("""
Notes:
Pods - error with terminal
w/ViewBuilder - composition, wout - Vstack is needed
Firebase - backend service(auth,saving data)
Networking service - Alamofire
""")

