//
//  DocumentPickerDelegate.swift
//  Dyscanner
//
//  Created by Vincenzo Gerelli on 16/12/24.
//
import UIKit
import PDFKit

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
