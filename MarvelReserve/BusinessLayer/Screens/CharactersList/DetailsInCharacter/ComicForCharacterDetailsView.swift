//
//  ComicForCharacterDetailsView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Kingfisher
import WebKit

struct ComicForCharacterDetailsView: View {
    var com: Items
    @State var Info: ComicDetails?
    @StateObject var vm = ApiForCharactersComic()
    
    
    var body: some View{
        ZStack{
            if vm.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                ScrollView{
                    VStack(alignment: .center, spacing: 20) {
                        HStack(alignment: .center){
                            KFImage(Extracters.extractImage(data: vm.comics?.thumbnail ?? ["":""] ))
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
                                    if vm.comics?.description == "" {
                                        Text("Description is not available")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal,3)
                                    } else {
                                        Text("Description")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Text(vm.comics?.description ?? "")
                                            .font(.title2)
                                            .padding(.horizontal,30)
                                    }
                                }
                                
                                VStack(alignment: .center, spacing: 8){
                                    if vm.comics?.creators.items != nil {
                                        Text("Creators")
                                            .padding(.bottom,5)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.text)
                                        ForEach(Array((vm.comics?.creators.items ?? []).enumerated()), id: \.offset) {idx, cr in
                                            Text("\(cr.role.capitalized): \(cr.name)")
                                                .id(idx)
                                                .padding(.horizontal,35)
                                                .font(.subheadline)
                                                .foregroundStyle(.text)
                                        }
                                    } else {
                                        Text("No Available Creators")
                                    }
                                }
                                .padding(20)
                                .background(.border)
                                .border(.clear, width: 1).cornerRadius(15)
                                
                                VStack(alignment: .center, spacing: 10){
                                    ForEach(vm.comics?.urls ?? [["":""]],  id: \.self){ url in
                                        NavigationLink(
                                            destination:
                                                WebDetailed(urlWeb: url)
                                            , label: {
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
                                .padding(.top,7)
                            }
                            Spacer()
                        }
                    }
                }
                .navigationTitle(vm.comics?.title ?? "")
            }
        }
        .onAppear {
            vm.getComicForCharacter(com)
        }
    }
}

#Preview {
    ComicForCharacterDetailsView(com: Items())
}
