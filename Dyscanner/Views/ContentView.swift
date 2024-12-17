import SwiftUI
import AVFoundation
import Foundation
import PDFKit

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    @State private var recognisedText = "This is where the scanned text will appear.\n\nTo start the process, tap the camera button below."
    @State private var showingScanningView = false
    @State private var showingSettingsView = false
    @State private var showCopiedOverlay = false
    let buttonHeight: CGFloat = 50

    private let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(settings.highContrast ? Color.black : Color(UIColor.secondarySystemBackground))
                            .shadow(radius: 3)
                        Text(recognisedText)
                            .font(Font.custom("OpenDyslexic-Regular", size: settings.fontSize))
                            .padding()
                            .foregroundColor(settings.highContrast ? Color.yellow : Color.primary)
                    }
                    .padding()
                }

                Spacer()

                HStack() {
                    // Camera Button
                    Button(action: {
                        self.showingScanningView = true
                    }) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(settings.highContrast ? Color.yellow : Color.primary.opacity(0.8))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Start Scanning")

                    Spacer()
                    
                    // Copy to Clipboard Button
                    ZStack {
                                // Main Button
                                Button(action: {
                                    copyToClipboard()
                                    withAnimation {
                                        showCopiedOverlay = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showCopiedOverlay = false
                                        }
                                    }
                                }) {
                                    Image(systemName: "doc.on.clipboard.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(settings.highContrast ? Color.yellow : Color.primary.opacity(0.8))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(recognisedText == "Tap button to start scanning")
                                .accessibilityLabel("Copy to Clipboard")

                                // Overlay
                                if showCopiedOverlay {
                                    Text("COPIED")
                                        .font(.caption)
                                        .background(Color.black.opacity(0.8))
                                        .cornerRadius(10)
                                        .offset(y: -55)
                                        .foregroundColor(.white)
                                        .transition(.opacity)
                                        .zIndex(1) // Ensure overlay appears above other content
                                }
                            }
                    Spacer()
                    
                    // SaveToPDF Button
                    Button(action: {
                        self.saveToPDF()
                    }) {
                        Image(systemName: "square.and.arrow.down.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(settings.highContrast ? Color.yellow : Color.primary.opacity(0.8))
                    }
                    .accessibilityLabel("Save as PDF")
                    Spacer()
                    
                    // Voiceover Button
                    Button(action: {
                        self.speakText()
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(settings.highContrast ? Color.yellow : Color.primary.opacity(0.8))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Read Text Aloud")
                }
                .padding()
                .padding(.horizontal, 20)
            }
            .background(settings.highContrast ? Color.black : Color(UIColor.systemBackground))
            .navigationBarTitle("Dyscanner")
            .navigationBarItems(trailing: Button(action: {
                self.showingSettingsView = true
            }) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundColor(settings.highContrast ? Color.yellow : Color.primary.opacity(0.8))
                    .padding(.trailing, 5)
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

    private func saveToPDF() {
        // Ensure the custom font is loaded
        guard let customFont = UIFont(name: "OpenDyslexic-Regular", size: settings.fontSize) else {
            print("Failed to load OpenDyslexic-Regular font.")
            return
        }
        
        // Generate PDF Metadata
        let pdfMetaData = [
            kCGPDFContextCreator: "Dyscanner",
            kCGPDFContextAuthor: "User"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Set PDF Page Size
        let pageWidth = 612.0
        let pageHeight = 792.0
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let pdfData = renderer.pdfData { context in
            context.beginPage()
            
            // Set up attributes for text rendering
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .paragraphStyle: paragraphStyle
            ]
            
            // Define a text rectangle and render text
            let textRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: pageHeight - 40)
            recognisedText.draw(in: textRect, withAttributes: attributes)
        }
        
        // Save PDF with Document Picker
        let fileName = "RecognisedText.pdf"
        let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: temporaryURL)
            let documentPicker = UIDocumentPickerViewController(forExporting: [temporaryURL])
            documentPicker.delegate = DocumentPickerDelegate()
            documentPicker.allowsMultipleSelection = false
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(documentPicker, animated: true, completion: nil)
            }
        } catch {
            print("Could not save PDF file: \(error.localizedDescription)")
        }
    }


}

#Preview {
    ContentView()
        .environmentObject(Settings())
}

