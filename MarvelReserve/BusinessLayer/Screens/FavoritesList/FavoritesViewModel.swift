//
//  FavoritesViewModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import Foundation
import SwiftUI
import Combine
import CryptoKit
import WebKit

class favoritesViewModel: ObservableObject{
    @Published var savedComics: Set<Int> = []
    @Published var cm = ComicsApiGetter()
    
    @Published var navBool = false
    @Published var selectedComic: Comic?
    
    var db = Database()
    var favComics: [Comic] {
        return cm.comicListExp.filter { savedComics.contains($0.id!) }
    }
   
    func setSelectedComicInFavoritesList(_ comic: Comic) {
        navBool = true
        selectedComic = comic
    }
    func contains(_ com: Comic) -> Bool {
        savedComics.contains(com.id!)
    }
    func toggleFav(com: Comic) {
        if contains(com) {
            savedComics.remove(com.id!)
        } else {
            savedComics.insert(com.id!)
        }
        db.save(com: savedComics)
    }
    init(){
        self.savedComics = db.load()
    }
}
