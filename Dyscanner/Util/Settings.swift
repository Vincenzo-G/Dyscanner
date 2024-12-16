//
//  AppSettings.swift
//  Dyscanner
//
//  Created by Vincenzo Gerelli on 16/12/24.
//
import SwiftUI

class Settings: ObservableObject {
    @Published var fontSize: Double = 25
    @Published var highContrast: Bool = false
}
