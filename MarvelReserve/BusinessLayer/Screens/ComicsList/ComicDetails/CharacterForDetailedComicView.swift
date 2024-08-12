//
//  CharacterForDetailedComicView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 19/06/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Kingfisher
import CryptoKit

struct CharacterForDetailedComicView: View {
    
    var char: ItemsCharacters
    
    @StateObject var vm = ApiForCharacterList()
    
    var body: some View{
        ZStack{
            if vm.isLoading{
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                ScrollView{
                    VStack(alignment: .center, spacing: 20) {
                        HStack(alignment: .center) {
                            KFImage(Extracters.extractImage(data: vm.character!.thumbnail ))
                                .aspectRatio(1, contentMode: .fill)
                                .frame(minWidth: 450, alignment: .center)
                                .scaledToFill()
                                .clipped()
                                .border(Color.black, width: 1).cornerRadius(15)
                        }
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
                                VStack(alignment: .center, spacing: 10){
                                    if vm.character?.description == "" {
                                        Text("Description is not available")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal,3)
                                    } else {
                                        Text("Description")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Text(vm.character?.description ?? "")
                                            .font(.title2)
                                            .padding(.horizontal,32)
                                    }
                                }
                                VStack(alignment: .center, spacing: 10){
                                    ForEach(vm.character!.urls  , id: \.self){ url in
                                        NavigationLink(
                                            destination:
                                                WebDetailed(urlWeb: url),
                                            label: {
                                                Text(Extracters.extractTypeURL(data: url))
                                            })
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.text)
                                        .frame(width: 250, height: 50, alignment: .center)
                                        .background(.buttonBG)
                                        .border(.clear).cornerRadius(15)
                                    }
                                }
                                .padding(7)
                            }
                            Spacer()
                        }
                    }
                }
                .navigationTitle(vm.character?.name ?? "Title")
            }
        }
        .onAppear{
            vm.getCharactersListInComic(char)
        }
    }
}


#Preview {
    CharacterForDetailedComicView(char: ItemsCharacters())
}
