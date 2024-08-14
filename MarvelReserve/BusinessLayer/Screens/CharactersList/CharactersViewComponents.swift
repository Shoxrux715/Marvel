//
//  CharactersViewComponents.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import SwiftUI
import Kingfisher

extension CharactersView {
    
    @ViewBuilder
    func searchCharacterView() -> some View {
        VStack(spacing: 15) {
            HStack( spacing: 10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Character", text: $vm.searchQuery)
                    .foregroundStyle(.text)
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(.border)
            .border(.border)
            .cornerRadius(15)
        }
        .padding(.horizontal)
        .padding(.vertical,5)
    }
    
    @ViewBuilder
    func cell(_ character: Character) -> some View {
        ZStack{
            HStack(alignment: .top, spacing: 15){
                KFImage(Extracters.extractImageURL(data: character.thumbnail))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .clipShape(Circle())
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 90, height: 90)
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 1))
                    .gesture(LongPressGesture(minimumDuration: 10.0)
                        .updating($imageBeingShown) { state, gesture, transaction in
                            selectedImageUrl = Extracters.extractImageURL(data: character.thumbnail)
                            gesture = state
                            transaction.animation = .smooth
                        }
                        .onEnded({ changed in
                            print("end")
                        }))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.text)
                        .multilineTextAlignment(.leading)
                    Text(character.description)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal)
    }
}
