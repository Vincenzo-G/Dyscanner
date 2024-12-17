# Dyscanner App

## Overview

Dyscanner is a text-scanning application designed with accessibility and ease of use in mind. It is particularly useful for individuals with dyslexia or visual impairments. The app allows users to scan documents, recognize text, and interact with the recognized content in multiple ways, including saving to a PDF, copying to the clipboard, or having the text read aloud.

The application is customizable, featuring a high-contrast mode and support for the OpenDyslexic font.

---

## Features

1. **Text Scanning:**
   - Use the device camera to scan documents and recognize text using VisionKit and Vision frameworks.

2. **High Contrast Mode:**
   - Toggle high contrast mode for better readability.

3. **Customizable Font:**
   - Supports the OpenDyslexic font, with adjustable font sizes for enhanced accessibility.

4. **Copy to Clipboard:**
   - Copy recognized text to the clipboard for easy sharing.

5. **Save as PDF:**
   - Save the recognized text to a PDF file using the OpenDyslexic font.

6. **Text-to-Speech:**
   - Read recognized text aloud using AVSpeechSynthesizer.

7. **Settings:**
   - Customize the app appearance and font settings.

---

## Screens and UI Components

### **Home Screen**
- **Text Display:** Shows recognized text within a scrollable, styled view.
- **Camera Button:** Opens the scanning interface.
- **Copy Button:** Copies the displayed text to the clipboard.
- **Save as PDF Button:** Converts the recognized text into a PDF and saves it.
- **Text-to-Speech Button:** Reads the text aloud.

### **Navigation Bar**
- Includes a settings button to access app configurations.

### **Settings View**
- Configure font size, high contrast mode, and other app preferences.

---

## How It Works

1. **Scanning Documents:**
   - Tap the camera button to open the scanning interface.
   - Use the Vision framework to extract text from scanned images.

2. **Viewing Recognized Text:**
   - The recognized text appears in the main view.
   - Customize the appearance of the text for better readability.

3. **Interacting with Text:**
   - Copy the text to the clipboard or save it as a PDF.
   - Use the text-to-speech feature to hear the text read aloud.

---

## Technical Details

### **Frameworks Used**
- **SwiftUI:** For building the user interface.
- **VisionKit and Vision:** For document scanning and text recognition.
- **AVFoundation:** For text-to-speech functionality.
- **PDFKit:** For creating and exporting PDF files.

### **Key Components**
- **`ScanDocumentView`:** Handles document scanning and text recognition.
- **`Settings`:** Environment object for managing user preferences.
- **`ContentView`:** Main view containing the text display and interactive buttons.

### **Custom Font**
- Utilizes the OpenDyslexic font to enhance readability for dyslexic users.

---

## Installation

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Ensure you have a physical iOS device or simulator with a camera.
4. Build and run the app.

---

## How to Use

1. Launch the app.
2. Tap the **Camera** button to scan a document.
3. View the recognized text on the main screen.
4. Use the action buttons to:
   - Copy text to the clipboard.
   - Save text as a PDF.
   - Have the text read aloud.

---

## Accessibility Features

- **High Contrast Mode:** Improves visibility for users with visual impairments.
- **OpenDyslexic Font:** Designed specifically for dyslexic readers.
- **Text-to-Speech:** Provides auditory access to text content.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Credits

- **OpenDyslexic Font:** [Visit OpenDyslexic](https://opendyslexic.org)
- **Developed by:** Vincenzo Gerelli
