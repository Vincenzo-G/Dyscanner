import SwiftUI
import AVFoundation
import Foundation
import PDFKit

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

                    // SaveToPDF Button
                    Button(action: {
                        self.saveToPDF()
                    }) {
                        Image(systemName: "square.and.arrow.down.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                    }
                    .accessibilityLabel("Save as PDF")
                    
                    
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
    
    private func saveToPDF() {
        // Generate PDF Data
        let pdfMetaData = [
            kCGPDFContextCreator: "Dyscanner",
            kCGPDFContextAuthor: "User"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 612.0
        let pageHeight = 792.0
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let pdfData = renderer.pdfData { context in
            context.beginPage()
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            recognisedText.draw(in: CGRect(x: 20, y: 20, width: pageWidth - 40, height: pageHeight - 40), withAttributes: attributes)
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

class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let savedURL = urls.first {
            print("PDF saved at: \(savedURL)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
}

#Preview {
    ContentView()
}

