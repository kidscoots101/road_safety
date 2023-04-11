//
//  CameraView.swift
//  Swift Student Challenge
//
//  Created by caleb on 11/4/23.
//

import SwiftUI
import Vision
import UIKit
import AVFoundation

struct CameraView: View {
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            CameraViewControllerRepresentable(image: $image)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewControllerRepresentable>) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.delegate = context.coordinator
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewControllerRepresentable>) {
        // Do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CameraViewControllerDelegate {
        let parent: CameraViewControllerRepresentable
        
        init(_ parent: CameraViewControllerRepresentable) {
            self.parent = parent
        }
        
        func didCaptureImage(_ image: UIImage) {
            parent.image = image
            parent.detectRoadSign(image: image)
        }
    }
    
    func detectRoadSign(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else {
                    print("No candidate found.")
                    continue
                }
                
                print("Detected text: \(topCandidate.string)")
            }
        }
        
        let requests = [request]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform(requests)
            } catch {
                print("Failed to perform OCR request: \(error).")
            }
        }
    }
}

protocol CameraViewControllerDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

class CameraViewController: UIViewController {
    weak var delegate: CameraViewControllerDelegate?
    
    private var captureSession: AVCaptureSession?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(captureDeviceInput) else {
            return
        }
        
        captureSession.addInput(captureDeviceInput)
        
        let capturePhotoOutput = AVCapturePhotoOutput()
        self.capturePhotoOutput = capturePhotoOutput
        
        guard captureSession.canAddOutput(capturePhotoOutput) else {
            return
        }
        
        captureSession.addOutput(capturePhotoOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
        func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            guard let captureSession = self.captureSession else {
                return
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        }
        func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            captureSession.stopRunning()
        }
    }}
