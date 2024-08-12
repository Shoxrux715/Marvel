//
//  WebView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: URL
    @ObservedObject var viewModel: ProgressViewModel
    let webView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        
        webView.load(URLRequest(url: url))
        return webView

    }
        

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}
