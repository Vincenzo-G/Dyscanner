//
//  SettingsView.swift
//  Dyscanner
//
//  Created by Vincenzo Gerelli on 15/12/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    @State private var showInfo: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Accessibility").foregroundColor(settings.highContrast ? Color.yellow : Color.primary)) {
                    Toggle("High Contrast", isOn: $settings.highContrast)
                        .foregroundStyle(settings.highContrast ? Color.yellow : Color.primary)
                }

                Section(header: Text("Text Settings").foregroundColor(settings.highContrast ? Color.yellow : Color.primary)) {
                    HStack {
                        Text("Font Size ")
                            .foregroundColor(settings.highContrast ? Color.yellow : Color.primary)
                        Spacer()
                        Slider(value: $settings.fontSize, in: 15...50, step: 1)
                            .accentColor(settings.highContrast ? Color.yellow : Color.blue)
                        Text("\(Int(settings.fontSize))")
                            .foregroundColor(settings.highContrast ? Color.yellow : Color.primary)
                    }
                }

                Section(header: Text("Information").foregroundColor(settings.highContrast ? Color.yellow : Color.primary)) {
                    Button(action: {
                        self.showInfo.toggle()
                    }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(settings.highContrast ? Color.yellow : Color.primary)
                            Text("About")
                                .foregroundColor(settings.highContrast ? Color.yellow : Color.primary)
                        }
                    }
                    .sheet(isPresented: $showInfo) {
                        InfoView()
                    }
                }
            }
            .background(settings.highContrast ? Color.black : Color(UIColor.systemBackground))
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }.foregroundColor(settings.highContrast ? Color.yellow : Color.blue))
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
        .environmentObject(Settings())
}
