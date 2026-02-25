//
//  CameraManager.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import AVFoundation
import SwiftUI
import Combine

final class CameraManager: NSObject, ObservableObject {
    
    @Published var capturedImage: UIImage?
    
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    override init() {
        super.init()
        sessionQueue.async {
            self.configure()
        }
    }
    
    private func configure() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        
        session.addInput(input)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              var image = UIImage(data: data) else { return }
        
        // Flip image horizontally if front camera
        if AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) != nil {
            image = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var manager: CameraManager
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.session = manager.session
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {}
}

final class PreviewView: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    var session: AVCaptureSession? {
        get { videoLayer.session }
        set {
            videoLayer.session = newValue
            videoLayer.videoGravity = .resizeAspectFill
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = bounds   
    }
}
