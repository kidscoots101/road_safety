//
//  Visual.swift
//  Swift Student Challenge
//
//  Created by caleb on 11/4/23.
//

import SwiftUI
import Vision
import UIKit

struct Visual: View {
    @State private var image: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Take a photo to detect road signs")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            Button("Take Photo") {
                showImagePicker.toggle()
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: detectRoadSign) {
            UIImagePickerController()
                .makeCoordinator()
                .sourceType = .camera
        }
    }
    
    func detectRoadSign() {
        guard let image = image,
              let ciImage = CIImage(image: image) else { return }
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            print(recognizedText)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

extension Visual: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            image = uiImage
        }
        showImagePicker.toggle()
    }
}

struct Visual_Previews: PreviewProvider {
    static var previews: some View {
        Visual()
    }
}
