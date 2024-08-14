//
//  DetailedComicView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Kingfisher
import CryptoKit

struct DetailedComicView: View{
  
    var Info: Comic?
   
    @State var thumbnail: [String:String]?
    
    @Environment(\.presentationMode) var presMode: Binding<PresentationMode>
    
    @ViewBuilder
    func CharacterCell(_ char: ItemsCharacters, _ index: Int) -> some View {
        HStack(alignment: .center){
            NavigationLink{
                CharacterForDetailedComicView(char: char)
            } label: {
                Text(String(index+1)+") "+(char.name ?? ""))
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
        .frame(width: 375)
    }
    
    @ViewBuilder
    func testCell(_ char: ItemsCharacters, _ index: Int) -> some View {
        NavigationLink{
            CharacterForDetailedComicView(char: char)
        } label: {
            VStack(alignment: .center) {
                Text(char.name ?? "")
                    .padding(1)
                    .font(.system(size: 10).italic()).foregroundStyle(.text)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 70, height: 70)
                    .aspectRatio(1, contentMode: .fit)
                    .background(.border)
                    .border(.clear, width: 1).cornerRadius(50)
            }
            .frame(width: 80, height: 90)
            .padding(.bottom, 10)
        }
        
    }
    
    var body: some View{
        if let list = Info?.characters.items{
            if list.isEmpty{
                EmptyView()
            } else {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(Array((list).enumerated()), id: \.offset) { idx, each in
                            testCell(each, idx)
                                .id(idx)
                        }
                    }
                }
                .frame(height: 80)
                Text("Tap a circle to observe a character")
                    .font(.system(size: 13))
                    .foregroundStyle(.text)
                    .padding(.horizontal,30)
            }
        }
        ScrollView{
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center){
                    KFImage(Extracters.extractImageURL(data: Info!.thumbnail ))
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
                            if Info?.description == "" {
                                Text("Description is not available")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal,3)
                            } else {
                                Text("Description")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(Info?.description ?? "")
                                    .font(.title2)
                                    .padding(.horizontal,30)
                            }
                        }
                        
                        if let charList = Info?.characters.items{
                            if charList.isEmpty {
                                Text("No Characters Available in this Comic")
                                    .font(.subheadline)
                                    .padding(.top,5)
                            } else {
                                Text("Available: \(Info?.characters.available ?? 0) character(s)")
                                    .font(.subheadline)
                                    .foregroundStyle(.text)
                                    .padding(.top, 10)
                                    .padding(.horizontal,30)
                                NavigationStack{
                                    ForEach(Array((charList).enumerated()), id: \.offset) { index, char in
                                        CharacterCell(char, index)
                                            .frame(width: 370)
                                            .border(.border, width: 1).cornerRadius(15)
                                    }
                                }
                                .padding(10)
                            }
                        }
                        HStack(alignment: .center){
                            VStack(alignment: .center, spacing: 8){
                                if Info?.creators.items != nil {
                                    Text("Creators")
                                        .padding(.bottom,5)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.text)
                                    ForEach(Array((Info?.creators.items ?? []).enumerated()), id: \.offset) {idx, cr in
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
                        }
                        HStack(alignment: .center){
                            VStack(alignment: .center, spacing: 10){
                                ForEach(Info!.urls ,  id: \.self) { url in
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
                        }
                        .padding(.top,7)
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle(Info?.title ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                    Image(systemName: "books.vertical.fill")
                        .scaleEffect(1)
                }
                
            }
        })
        
    }
    func urlForEach(url: String) -> [String:String] {
        let ts = String(Date().timeIntervalSince1970)
        let hash = Converters.MD5(data: "\(ts)\(Constants.apiPrivateKey)\(Constants.apiPublicKey)")
        let mb = url+"?ts=\(ts)&apikey=\(Constants.apiPublicKey)&hash=\(hash)"
        let session = URLSession(configuration: .default)
        session.dataTask(with: Converters.convertToSecureURL(url: URL(string: mb)!)) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            do{
                let thumb = try JSONDecoder().decode(DetailedModel.self, from: data )
                DispatchQueue.main.async{ [self] in
                    thumbnail = thumb.data.results.first!.thumbnail
                    print("Success")
                }
                
            } catch(let err) {
                print("Error:", err)
            }
        }
        return thumbnail ?? ["":""]
    }
}
struct WebDetailed: View {
    var urlWeb: [String:String]
    
    @StateObject var viewModel = WebView.ProgressViewModel(progress: 0.0)
    @Environment(\.navigationManager) var nvmanager
    
    var body: some View {
        VStack{
            ZStack{
                WebView(url: extractURL(data: urlWeb), viewModel: viewModel)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            nvmanager.wrappedValue.popToRoot(tag: "nv1") 
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
    func extractURL(data: [String: String]) -> URL{
        let url = data["url"] ?? ""
        return URL(string: url)!
    }
}
