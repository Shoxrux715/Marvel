//
//  FavoritesModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import Foundation

final class Database{
    private let FAV_KEY = "fav_key"
    
    func save(com: Set<Int>) {
        let array = Array(com)
        UserDefaults.standard.set(array, forKey: FAV_KEY)
    }
    func load() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: FAV_KEY) as? [Int] ?? [Int]()
        return Set(array)
    }
}
