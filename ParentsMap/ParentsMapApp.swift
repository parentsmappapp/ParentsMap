//
//  ParentsMapApp.swift
//  ParentsMap
//
//  Created by Mariia on 30/5/2026.
//

import SwiftUI

@main
struct ParentsMapApp: App {
    
    init() {
        registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func registerFonts() {
        let fonts = [
            "Quicksand-Bold",
            "Quicksand-Light",
            "Quicksand-Medium",
            "Quicksand-Regular",
            "Quicksand-SemiBold",
            "Poppins-Black",
            "Poppins-BlackItalic",
            "Poppins-Bold",
            "Poppins-BoldItalic",
            "Poppins-Italic",
            "Poppins-Light",
            "Poppins-LightItalic",
            "Poppins-Medium",
            "Poppins-MediumItalic",
            "Poppins-ThinItalic"
        ]
        
        for font in fonts {
            guard let url = Bundle.main.url(forResource: font, withExtension: "ttf"),
                  let data = try? Data(contentsOf: url),
                  let provider = CGDataProvider(data: data as CFData),
                  let cgFont = CGFont(provider) else {
                print("❌ Failed to load font: \(font)")
                continue
            }
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterGraphicsFont(cgFont, &error)
            print("✅ Loaded font: \(font)")
        }
    }
}
