//
//  WebView+Extensions.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI
import Foundation


extension WebView {

    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }

    class Coordinator: NSObject {
        private var parent: WebView
        private var viewModel: ProgressViewModel
        private var observer: NSKeyValueObservation?

        init(_ parent: WebView, viewModel: ProgressViewModel) {
            self.parent = parent
            self.viewModel = viewModel
            super.init()

            observer = self.parent.webView.observe(\.estimatedProgress) { [weak self] webView, _ in
                guard let self = self else { return }
                self.parent.viewModel.progress = webView.estimatedProgress
            }
        }

        deinit {
            observer = nil
        }
    }
}
extension WebView {
    class ProgressViewModel: ObservableObject {
        @Published var progress: Double = 0.0

        init (progress: Double) {
            self.progress = progress
        }
    }
}

