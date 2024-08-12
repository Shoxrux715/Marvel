//
//  CharactersView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import Kingfisher
import NavigationViewKit

struct CharactersView: View {
    
    @StateObject var vm = CharacterApiGetter()
    
    @GestureState var imageBeingShown = false
    @State var selectedImageUrl: URL?
    
    var body: some View {
        ZStack{
            NavigationStack{
                ScrollView(.vertical, showsIndicators: false,content: {
                    
                    searchCharacterView()
                    
                    if let characters = vm.charactersList{
                        if characters.isEmpty {
                            Text("No Result")
                                .padding(.top, 20)
                        } else {
                            VStack(spacing: 12){
                                ForEach(characters){ character in
                                    Button(action: {
                                        vm.setSelectedCharacter(character)
                                    }, label: {
                                       cell(character)
                                    })
                                }
                            }
                        }
                    } else {
                        if vm.isLoading {
                            ProgressView()
                                .padding(.top,20)
                        }
                    }
                    
                })
                .onAppear{
                    AppState.shared.swipeEnabled = false
                }
                .onDisappear{
                    AppState.shared.swipeEnabled = true
                }
                .navigationBarTitle("Characters", displayMode: .inline)
                .refreshable {
                    vm.refresh()
                }
                .navigationDestination(isPresented: $vm.charactersNavigate) {
                    DetailedCharactersView(Info: vm.tappedCharacter)
                }
            }
            .navigationViewManager(for: "nv2")
            
            if imageBeingShown {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if let url = selectedImageUrl {
                            withAnimation(.smooth) {
                                KFImage(url)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 300, height: 300)
                                    .scaledToFit()
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color.black.opacity(0.5))
                .ignoresSafeArea()
            }
        }
    }
}


#Preview {
    CharactersView()
}
