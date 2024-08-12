//
//  FavouritesView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 25/06/24.
//

import SwiftUI
import Kingfisher

struct FavouritesView: View {
    
    @EnvironmentObject var vm: favoritesViewModel
    
    @ViewBuilder
    func favCell(_ comics: Comic) -> some View {
        Button {
            vm.setSelectedComicInFavoritesList(comics)
        } label: {
            HStack(alignment: .top, spacing: 20){
                HStack(alignment: .center){
                    KFImage(Extracters.extractImage(data: comics.thumbnail))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .clipShape(Circle())
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                }
                VStack(alignment: .leading, spacing: 5){
                    Text(comics.title ?? "")
                        .lineLimit(3)
                        .foregroundStyle(.text)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .frame(alignment: .topLeading)
                    
                }
                .padding(.top,10)
                Spacer()
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                    vm.toggleFav(com: comics)
                }, label: {
                    Image(systemName: vm.contains(comics) ? "heart.fill" : "heart")
                        .scaleEffect(1.5)
                        .foregroundStyle(.red)
                        .padding(.top, 20)
                })
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationStack{
                List{
                    ForEach(vm.favComics) { com in
                        favCell(com)
                            .padding(.horizontal,5)
                            .padding(.top,5)
                    }
                }
                .navigationTitle("Favourites").navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $vm.navBool) {
                    DetailedComicView(Info: vm.selectedComic)
                }
            }
        }
    }
    
}

