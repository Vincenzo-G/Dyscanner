//
//  SettingsView.swift
//  Dyscanner
//
//  Created by Vincenzo Gerelli on 15/12/24.
//

import SwiftUI

// Updated SettingsView with accessibility, contrast, font size options, and cancel button
struct SettingsView: View {
    @State private var fontSize: Double = 25
    @State private var highContrast: Bool = false
    @State private var showInfo: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Accessibility")) {
                    Toggle("High Contrast", isOn: $highContrast)
                }

                Section(header: Text("Text Size")) {
                    HStack {
                        Text("Font Size")
                        Spacer()
                        Slider(value: $fontSize, in: 15...50, step: 1) {
                            Text("Font Size")
                        }
                        Text("\(Int(fontSize))")
                    }
                }

                Section(header: Text("Information")) {
                    Button(action: {
                        self.showInfo.toggle()
                    }) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("About This App")
                        }
                    }
                    .sheet(isPresented: $showInfo) {
                        InfoView()
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .background(Color(UIColor.systemBackground))
        }
    }
}

// Info View Placeholder
struct InfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "info.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            Text("Dyscanner 4.0")
                .font(.title)
                .bold()
            Text("This app is designed to assist with text recognition and accessibility for individuals with dyslexia and other reading difficulties.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
