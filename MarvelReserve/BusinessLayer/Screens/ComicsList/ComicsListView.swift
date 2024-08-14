//
//  ComicsView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import Kingfisher
import NavigationViewKit

struct ComicsListView: View {
    
    @StateObject var vm = ComicsApiGetter()
    
    @State var comicToDelete: Comic?
    
    @State var selectedImageUrl: URL?
    
    @GestureState var imageBeingShown = false
    @EnvironmentObject var favoritesViewModel: favoritesViewModel
    
    
    var body: some View{
        if let errorMessage = vm.error {
            VStack(alignment: .center){
                Text("Error: \(errorMessage)")
            }
        } else {
            ZStack {
                NavigationStack{
                    VStack {
                        
                        searchComicView()
                        
                        ZStack {
                            ScrollViewReader { value in
                                ZStack {
                                    List {
                                        ForEach(Array((vm.comicListExp).enumerated()), id: \.offset) {  idx, comics in
                                            
                                            cell(comics)
                                            
                                                .id(comics)
                                                .onAppear{
                                                    if comics.id == vm.comicsList.last?.id {
                                                        vm.loadComicsList()
                                                    }
                                                }
                                                .swipeActions{
                                                    Button{
                                                        vm.deleteAlert = true
                                                        comicToDelete = comics
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                        }
                                        .alert(isPresented: $vm.deleteAlert) {
                                            Alert(title: Text("Do you want to delete the comic?"),
                                                  message: Text("Once you delete the comic, you can not return it"),
                                                  primaryButton: .destructive(Text("Delete")) {
                                                delete()
                                            },
                                                  secondaryButton: .cancel())
                                        }
                                        
                                    }
                                    .refreshable {
                                        vm.isLoading = true
                                        vm.refreshComicsList()
                                    }
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Button {
                                                withAnimation {
                                                    value.scrollTo(vm.comicsList.first)
                                                }
                                            } label: {
                                                Image(systemName: "arrowshape.up")
                                            }
                                            .background(Color.black.opacity(0.3).frame(width: 50, height: 50).cornerRadius(30))
                                            .font(.largeTitle)
                                            .padding()
                                        }
                                    }
                                }
                                
                            }
                            if vm.isLoading {
                                ProgressView()
                                    .scaleEffect(1.5)
                            }
                        }
                    }
                    .onAppear{
                        AppState.shared.swipeEnabled = false
                    }
                    .onDisappear{
                        AppState.shared.swipeEnabled = true
                    }
                    .navigationBarTitle("Comics List", displayMode: .inline)
                    .navigationDestination(isPresented: $vm.navigate) {
                        DetailedComicView(Info: vm.tappedComics)
                    }
                }
                .navigationViewManager(for: "nv1")
                
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
                                        .scaledToFill()
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
    func delete(){
        vm.comicsList = vm.comicsList.filter(){ $0 != comicToDelete }
    }
}


#Preview {
    ComicsListView()
}
