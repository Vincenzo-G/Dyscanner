//
//  Dyscanner4_0App.swift
//  Dyscanner4.0
//
//  Created by Vincenzo Gerelli on 10/12/24.
//

import SwiftUI

@main
struct DyscannerApp: App {
    @StateObject private var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
