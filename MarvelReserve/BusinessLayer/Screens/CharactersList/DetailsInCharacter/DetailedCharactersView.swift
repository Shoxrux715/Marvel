//
//  DetailedCharactersView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//


import SwiftUI
import SDWebImageSwiftUI
import Kingfisher
import CryptoKit

struct DetailedCharactersView: View {
   
    var Info: Character?
    
    @Environment(\.presentationMode) private var presModeChar: Binding<PresentationMode>
    
    @ViewBuilder
    func DetailsCell(_ com: Items, _ index: Int) -> some View {
        
        HStack(alignment: .center){
            NavigationLink {
                ComicForCharacterDetailsView(com: com)
            } label: {
                Text(String(index+1)+") "+(com.name ?? ""))
                Spacer()
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 15).bold())
            .foregroundStyle(.text)
            .padding(.vertical, 2)
            .padding(.horizontal,15)
            .lineLimit(1)
            .background(.border)
        }
    }
    var body: some View{
        ScrollView{
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center){
                    KFImage(Extracters.extractImage(data: Info!.thumbnail))
                        .aspectRatio(1, contentMode: .fill)
                        .frame(minWidth: 450, alignment: .center)
                        .scaledToFill()
                        .clipped()
                        .border(Color.black, width: 1).cornerRadius(15)
                }
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center){
                        VStack(alignment: .center, spacing: 10){
                            if Info?.description == "" {
                                Text("Description is not available")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(alignment: .center)
                                    .padding(.horizontal,3)
                            } else {
                                Text("Description")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(alignment: .center)
                                Text(Info?.description ?? "")
                                    .font(.title2)
                                    .padding(.horizontal,32)
                                    .frame(alignment: .center)
                            }
                        }
                        VStack(alignment: .center , spacing: 10){
                            Text("Comics, where \(Info?.name.uppercased() ?? "") acted")
                                .lineLimit(2)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.text)
                                .padding(.horizontal,20)
                            Text("Available: \(Info?.comics.available ?? 0) comics")
                                .font(.subheadline)
                                .foregroundStyle(.text)
                        }
                        .padding(.top, 10)
                        .padding(.horizontal,30)
                        
                        if let items = Info?.comics.items {
                            if items.isEmpty {
                                Text("Coming soon..")
                                    .font(.subheadline)
                                    .padding(.top,5)
                            } else {
                                NavigationStack{
                                    ForEach(Array((items).enumerated()), id: \.offset) {index, com in
                                        DetailsCell(com, index)
                                            .frame(width: 370)
                                            .border(.border, width: 1).cornerRadius(15)
                                    }
                                }
                                .padding(10)
                            }
                        }
                        HStack(alignment: .center){
                            VStack(alignment: .center, spacing: 10){
                                ForEach(Info!.urls  , id: \.self){ url in
                                    NavigationLink(
                                        destination:
                                            WebDetailedForChar(urlWeb: url),
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
                        }
                        .padding(7)
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presModeChar.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                    Image(systemName: "person.3.fill")
                        .scaleEffect(1)
                }
                
            }
        })
        .navigationTitle(Info?.name ?? "Title")
    }
}

struct WebDetailedForChar: View {
    var urlWeb: [String:String]
    @StateObject var viewModel = WebView.ProgressViewModel(progress: 0.0)
    @Environment(\.navigationManager) var nvmanager2
    
    var body: some View {
        VStack{
            ZStack{
                WebView(url: Extracters.extractURL(data: urlWeb), viewModel: viewModel)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            nvmanager2.wrappedValue.popToRoot(tag: "nv2")
                        } label: {
                            Image(systemName: "house")
                                .scaleEffect(0.7)
                        }
                        .background(Color.black.opacity(0.3).frame(width: 50, height: 50).cornerRadius(30))
                        .font(.largeTitle)
                        .padding()
                    }
                }
            }
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    DetailedCharactersView()
}
