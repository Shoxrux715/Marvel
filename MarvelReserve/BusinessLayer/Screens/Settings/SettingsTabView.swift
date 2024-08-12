//
//  SettingsTabView.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import SwiftUI

struct SettingsTabView: View {
   
    @Environment(LanguageSetting.self) var languageSettings
   
    @State var switchLanguageEng = false
    @State var switchLanguageRus = false
    
    @State private var changeTheme = false
    @Environment(\.colorScheme) private var scheme
    
    @AppStorage("userTheme") private var userTheme: Schemes = .systemDefault
    
    @AppStorage("selectedTintColor") var selectedTintColor: String?
    @State var tintColor: Color = .accentColor
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        switchLanguageEng.toggle()
                    }, label: {
                        Text("English")
                            .font(.title3)
                            .foregroundStyle(.text)
                            .padding(.horizontal,2)
                    }).alert(isPresented: $switchLanguageEng) {
                        Alert(title: Text("Are you sure you want to change the app language"), primaryButton: .default(Text("Yes"), action: {
                            languageSettings.locale = Locale(identifier: "EN")
                        }), secondaryButton: .cancel() )
                    }
                    Button(action: {
                        switchLanguageRus.toggle()
                    }, label: {
                        Text("Russian")
                            .font(.title3)
                            .foregroundStyle(.text)
                            .padding(.horizontal,2)
                    }).alert(isPresented: $switchLanguageRus) {
                        Alert(title: Text("Are you sure you want to change the app language"), primaryButton:  .default(Text("Yes"), action: {
                            languageSettings.locale = Locale(identifier: "RU")
                        }), secondaryButton: .cancel())
                    }
                } header: {
                    Text("Language")
                }
                Section {
                    Button(action: {
                        changeTheme.toggle()
                    }, label: {
                        Text("Change App Theme")
                            .font(.title3)
                            .foregroundStyle(.text)
                            .padding(.horizontal,2)
                    })
                } header: {
                    Text("Theme")
                }
                Section {
                    ColorPicker(selection: $tintColor ) {
                            Text("Change Tint Color")
                                .font(.title3)
                                .foregroundStyle(.text)
                                .padding(.horizontal,2)
                    }
                    .onChange(of: tintColor) {
                        selectedTintColor = tintColor.toHex()
                    }
                } header: {
                    Text("Color")
                }
                
            }
            .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
        }
        .tint(tintColor)
        .sheet(isPresented: $changeTheme, content: {
            ThemeChanger(scheme: scheme)
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
extension Color{
    
}
@Observable
class LanguageSetting {
    var locale = Locale(identifier: "en")
}
enum TintColor: String, CaseIterable{
    case a, b,c
    var chtoto: Color{
        switch self{
        case .a:
            return .blue
        case .b:
            return .green
        case .c:
            return .red
        }
    }
}

#Preview {
    SettingsTabView()
}

