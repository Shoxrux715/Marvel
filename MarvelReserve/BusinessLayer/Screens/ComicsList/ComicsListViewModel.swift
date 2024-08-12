//
//  ComicsListViewModel.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 07/08/24.
//

import Foundation
import SwiftUI
import Combine
import CryptoKit
import WebKit


class ComicsApiGetter: ObservableObject {
    
    @Published var info: ComicsModel?
    @Published var infoForComic: ComicsModel?
    
    @Published var comicsList: [Comic] = []
    @Published var comicsListForSearch: [Comic] = []
    
    @Published var showAlert = false
    @Published var isLoading = true
    @Published var deleteAlert: Bool = false
    
    @Published var navigate: Bool = false
    @Published var tappedComics: Comic?
    
    @Published var searchQueryComic = "" {
        didSet {
            if searchQueryComic == ""{
                isLoading = false
            } else {
                isLoading = true
                getComicsStartWithList()
            }
        }
        
    }
    
    var comicListExp: [Comic] {
        if searchQueryComic == ""{
            return comicsList
        } else {
            return comicsListForSearch
        }
    }
    
    var searchCancellableComic: AnyCancellable? = nil
    
    lazy var error = ""
    
    private var offsetPage = 0
    
    
    init() {
        loadData()
    }
    
    func getComicsList() async throws {
        let ts = String(Date().timeIntervalSince1970)
        let hash = Converters.MD5(data: "\(ts)\(Constants.apiPrivateKey)\(Constants.apiPublicKey)")
        let urlString =
        "https://gateway.marvel.com:443/v1/public/comics?ts=\(ts)&offset=\(offsetPage)&apikey=\(Constants.apiPublicKey)&hash=\(hash)"
        guard let url = URL(string: urlString) else {
            return
        }
        
//        comicModel.extra
        
        var request  = URLRequest(url: url)
        request.timeoutInterval = 180.0
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Error: \(err)")
//                throw NSError()
            }
            guard let data = data else {
                return
            }
            do {
                self.offsetPage+=1
                let inform = try JSONDecoder().decode(ComicsModel.self, from: data)
                DispatchQueue.main.async { [self] in
                    isLoading = false
                    info = inform
                    comicsList.append(contentsOf: info?.data.results ?? [] )
                }
            } catch {
//                throw NSError()
                print("Error in catch: \(error)")
            }
        }.resume()
        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            throw MVError.invalidResponse
//        }
        
//        do {
//            offsetPage+=1
//            guard
//                let Inform = try? JSONDecoder().decode(ComicsModel.self, from: data)
//            else {
//                throw MVError.invalidData
//            }
//            DispatchQueue.main.async { [self] in
//                isLoading = false
//                info = Inform
//                comicsList.append(contentsOf: info?.data.results ?? [])
//            }
//        }
//        catch {
//            throw MVError.invalidData
//        }
    }
    
    func getComicsStartWithList() {
        let ts = String(Date().timeIntervalSince1970)
        let hash = Converters.MD5(data: "\(ts)\(Constants.apiPrivateKey)\(Constants.apiPublicKey)")
        let titleStartsWith = searchQueryComic.replacingOccurrences(of: "", with: "%20")
        let url = "https://gateway.marvel.com:443/v1/public/comics?titleStartsWith=\(titleStartsWith)&ts=\(ts)&orderBy=title&offset=\(offsetPage)&apikey=\(Constants.apiPublicKey)&hash=\(hash)"
        var request  = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 180.0
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            do{
                let forSearch = try JSONDecoder().decode(ComicsModel.self, from: data)
                DispatchQueue.main.async{[self] in
                    infoForComic = forSearch
                    comicsListForSearch = forSearch.data.results
                    print("URLRequestComic: Success")
                    isLoading = false
                }
            } catch {
                print("URLRequestComic Error:", String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
    
    func setSelectedComic(_ comic: Comic) {
        navigate = true
        tappedComics = comic
    }
    
    func loadData() {
        Task(priority: .high) {
            do {
                try await getComicsList()
            } catch(let err) {
                showAlert = true
                error = err.localizedDescription
            }
        }
    }
    
    func refresh(){
        comicsList.removeAll()
        offsetPage = 0
        loadData()
    }
    
}
