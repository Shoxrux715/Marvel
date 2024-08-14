//
//  ThemeChanger.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI

struct ThemeChangerView: View {
    
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Schemes = .systemDefault
   
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15){
            Circle()
                .fill(userTheme.color(scheme).gradient)
                .frame(width: 150, height: 150)
            Text("Choose a Style")
                .font(.title2.bold())
                .padding(.top,25)
            HStack(spacing: 0){
                ForEach(Schemes.allCases, id: \.rawValue){theme in
                    Text(theme.rawValue)
                        .padding(.vertical,10)
                        .frame(width: 100)
                        .background{
                            ZStack{
                                if userTheme == theme {
                                    Capsule()
                                        .fill(.BG)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                            .animation(.snappy, value: userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(.BG)
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal,15)
        .environment(\.colorScheme, scheme)
    }
}


enum Schemes: String, CaseIterable{
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    func color(_ scheme: ColorScheme) -> Color{
        switch self{
        case .systemDefault:
            return scheme == .dark ? .moon : .sun
        case .light:
            return .sun
        case .dark:
            return .moon
        }
    }
    var colorScheme: ColorScheme?{
        switch self{
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
