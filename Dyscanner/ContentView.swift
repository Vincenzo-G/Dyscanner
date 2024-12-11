//
//  ContentView.swift
//  Dyscanner4.0
//
//  Created by Vincenzo Gerelli on 10/12/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State private var recognisedText = "Press Start Scanning Button"
    @State private var showingScanningView = false
    let buttonHeight: CGFloat = 50
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(radius: 3)
                        Text(recognisedText)
                            .font(Font.custom("OpenDyslexic-Regular", size: 25))
                            .padding()
                        
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    
                    Button(action:{
                        self.showingScanningView = true
                    }){
                        Text("Start Scanning")
                            .frame(width: 150, height: buttonHeight)
                            .padding()
                            .foregroundColor(.white)
                            .background(Capsule().fill(Color.blue))
                    }
                    
                    Button(action:{
                        self.copyToClipboard()
                    }){
                        Text("Copy to Clipboard")
                            .frame(width: 150, height: buttonHeight)
                            .padding()
                            .foregroundColor(.white)
                            .background(Capsule().fill(Color.green))
                    }
                    .disabled(recognisedText == "Tap button to start scanning")
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .navigationBarTitle("Dyscanner")
            .sheet(isPresented: $showingScanningView){
                ScanDocumentView(recognisedText: self.$recognisedText)
            }
        }
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = recognisedText
    }
}

#Preview {
    ContentView()
}
