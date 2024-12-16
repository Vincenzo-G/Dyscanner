import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @State private var recognisedText = "This is where the scanned text will appear.\n\nTo start the process, tap the camera button below."
    @State private var showingScanningView = false
    @State private var showingSettingsView = false
    let buttonHeight: CGFloat = 50

    private let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(UIColor.secondarySystemBackground)) // Adaptive background color
                            .shadow(radius: 3)
                        Text(recognisedText)
                            .font(Font.custom("OpenDyslexic-Regular", size: 25))
                            .padding()
                            .foregroundColor(Color.primary) // Adaptive text color
                    }
                    .padding()
                }

                Spacer()

                HStack(spacing: 20) {
                    // Camera Button
                    Button(action: {
                        self.showingScanningView = true
                    }) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Start Scanning")

                    // Copy to Clipboard Button
                    Button(action: {
                        self.copyToClipboard()
                    }) {
                        Image(systemName: "doc.on.clipboard.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(recognisedText == "Tap button to start scanning")
                    .accessibilityLabel("Copy to Clipboard")

                    // Voiceover Button
                    Button(action: {
                        self.speakText()
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Read Text Aloud")
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground)) // Adaptive background color
            .navigationBarTitle("Dyscanner")
            .navigationBarItems(trailing: Button(action: {
                self.showingSettingsView = true
            }) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $showingScanningView) {
                ScanDocumentView(recognisedText: self.$recognisedText)
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
        }
    }

    private func copyToClipboard() {
        UIPasteboard.general.string = recognisedText
    }

    private func speakText() {
        let utterance = AVSpeechUtterance(string: recognisedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
}



#Preview {
    ContentView()
}

