//
//  ContentView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MarvelTabView: View {
    
    @StateObject var MarvelModelForView = ComicsApiGetter()
    @State var tappedComics: Comic?
    @StateObject var NetworkModel = NetworkManager()
    @State var SettingUI = SettingsTabView()
    @AppStorage("selectedTintColor") var selectedTintColor: String?
    @StateObject var vModel = favoritesViewModel()
    
    var body: some View {
        ZStack{
            if NetworkModel.isConnected {
                TabView {
                    ComicsListView()
                        .tabItem {
                            Label(LocalizedStringKey("Comics List"), systemImage: "books.vertical.fill")
                        }
                    CharactersView()
                        .tabItem {
                            Label("Characters", systemImage: "person.3.fill")
                        }
                        .environmentObject(MarvelModelForView)
                    FavouritesView()
                        .tabItem {
                            Label("Favourites", systemImage: "heart.fill")
                        }
                    SettingsTabView()
                        .tabItem {
                            Label(LocalizedStringKey("Settings"), systemImage: "gearshape")
                        }
                }
            } else {
                VStack{
                    Image(systemName: NetworkModel.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.vertical,50)
                    Text(NetworkModel.textConnection)
                        .font(.system(size: 20))
                }
                .environmentObject(NetworkModel)
                .padding(.bottom,100)
                
            }
            
        }.tint(Color(hex: selectedTintColor ?? "#0000FF"))
    }
    
}

enum MVError: Error, CodingKey{
    case invalidData
    case invalidResponse
    case invalidURL
}



#Preview("English") {
    MarvelTabView()
        .environment(\.locale, Locale(identifier:"EN"))
}
#Preview("Russian") {
    MarvelTabView()
        .environment(\.locale, Locale(identifier:"RU"))
}

