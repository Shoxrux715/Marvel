//
//  SplashScreenView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI


struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 1.0
    @State private var opacity = 0.5
    @State var languageSettings = LanguageSetting()
    @Environment(\.colorScheme) private var scheme
    @AppStorage("userTheme") private var userTheme: Schemes = .systemDefault
    @StateObject private var viewModel = favoritesViewModel()
    var body: some View{
        if isActive {
            MarvelTabView()
                .environment(languageSettings)
                .environment(\.locale, languageSettings.locale)
                .preferredColorScheme(userTheme.colorScheme)
                .environmentObject(viewModel)
//                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        } else {
            VStack{
                Image("Marvel")
                    .scaledToFit()
                    .foregroundColor(.red)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.5)) {
                    self.size = 1.1
                    self.opacity = 1.0
                }
            }
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashScreenView()
}

