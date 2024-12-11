import SwiftUI
import Foundation
import VisionKit
import Vision

struct ScanDocumentView: UIViewControllerRepresentable {
            
        @Environment(\.presentationMode) var presentationMode
        
        @Binding var recognisedText: String
        
        func makeCoordinator() -> Coordinator {
            
            Coordinator(recognisedText: $recognisedText, parent: self)
            
        }
        
        func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
            let documentViewController = VNDocumentCameraViewController()
            
            documentViewController.delegate = context.coordinator
            
            return documentViewController
        }
        
        func updateUIViewController(
            _ uiViewController: VNDocumentCameraViewController,
            context: Context
        ) {
            
        }
        
        class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
            
            var recognisedText: Binding<String>
            var parent: ScanDocumentView
            
            init(recognisedText: Binding<String>, parent: ScanDocumentView) {
                self.recognisedText = recognisedText
                self.parent = parent
            }
            
            func documentCameraViewController(
                _ controller: VNDocumentCameraViewController,
                didFinishWith scan: VNDocumentCameraScan
            ) {
                
                let extractedImages = extractImages(from: scan)
                
                let processedText = recogniseText(from: extractedImages)
                
                recognisedText.wrappedValue = processedText
                
                parent.presentationMode.wrappedValue.dismiss()
                
            }
            
            fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage]{
                
                var extractedImages = [CGImage]()
                
                for index in 0..<scan.pageCount{
                    
                    let extractedImage = scan.imageOfPage(at: index)
                    
                    guard let cgImage = extractedImage.cgImage else {
                        continue
                    }
                    
                    extractedImages.append(cgImage)
                    
                }
                
                return extractedImages
            
            }
            
            fileprivate func recogniseText(from images: [CGImage]) -> String{
                var entireRecognisedText = ""
                
                let recognisedTextRequest = VNRecognizeTextRequest { request, error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
                    
                    let maximumRecognitionCandidates = 1
                        
                    for observation in observations {
                        guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else {continue}
                        
                        
                        entireRecognisedText += "\(candidate.string)\n"
                        
                    }
                    
                    }
                
                recognisedTextRequest.recognitionLevel = .accurate
                
                for image in images {
                    
                    let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                    
                    try? requestHandler.perform([recognisedTextRequest])
                    
                }
                
                return entireRecognisedText
                    
                }
            }
            
    }


