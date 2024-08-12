//
//  ComicsListComponents.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 09/08/24.
//

import SwiftUI
import Kingfisher

extension ComicsView {
   
    @ViewBuilder
    func searchComicView() -> some View{
        VStack {
            HStack{
                HStack( spacing: 10){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Comic", text: $vm.searchQueryComic)
                        .foregroundStyle(.text)
                }
                .padding(.vertical,10)
                .padding(.horizontal)
                .background(.border)
                .border(.border)
                .cornerRadius(15)
            }
        }
        .padding(.horizontal)
        .padding(.vertical,5)
    }
    
    
    @ViewBuilder
    func cell(_ comics: Comic) -> some View {
        Button {
            vm.setSelectedComic(comics)
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
                        .gesture(LongPressGesture(minimumDuration: 10.0)
                            .updating($imageBeingShown) { state, gesture, transaction in
                                selectedImageUrl = Extracters.extractImage(data: comics.thumbnail)
                                gesture = state
                                transaction.animation = .smooth
                            }
                            .onEnded({ changed in
                                print("end")
                            }))
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
                HStack(alignment: .top ){
                    Spacer()
                    VStack(alignment: .center, spacing: 10){
                        if comics.prices.first?.price == 0.0 {
                            Text("Free")
                                .foregroundStyle(.text).font(.system(size: 13)).fontWeight(.bold)
                                .padding(.top,10)
                                .lineLimit(1)
                        } else {
                            Text("USD \(String(describing: comics.prices.first!.price))")
                                .lineLimit(1)
                                .foregroundStyle(.text).font(.system(size: 11)).fontWeight(.bold)
                                .padding(8)
                                .background(.buttonBG)
                                .border(.clear).cornerRadius(10)
                                .padding(.top,10)
                        }
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()
                            favoritesViewModel.toggleFav(com: comics)
                        } label: {
                            Image(systemName: favoritesViewModel.contains(comics) ? "heart.fill" : "heart")
                                .scaleEffect(1.5)
                                .foregroundStyle(.red)
                                .frame(width: 30, height: 30, alignment: .center)
                        }
                    }
                    .frame(width: 80, alignment: .center)
                }
            }
        }
    }

}
