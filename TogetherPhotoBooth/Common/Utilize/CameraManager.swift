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
    @Published var capturedImages: [UIImage] = []
    
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    @Published var currentPosition: AVCaptureDevice.Position = .front
    private var isConfigured = false
    
    override init() {
        super.init()
        sessionQueue.async { [weak self] in
            self?.configure()
        }
    }
    
    // MARK: - Configure session
    private func configure() {
        session.beginConfiguration()
        
        // Remove old inputs
        session.inputs.forEach { session.removeInput($0) }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: currentPosition),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        
        session.addInput(input)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        isConfigured = true
    }
    
    // MARK: - Session control
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self, self.isConfigured else { return }
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    private func startSessionSafely() {
        sessionQueue.asyncAfter(deadline: .now() + 0.2) {
            if !self.session.isRunning, self.isConfigured {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    // MARK: - Switch camera
    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let wasRunning = self.session.isRunning
            if wasRunning { self.session.stopRunning() }
            
            // Toggle camera position safely
            let newPosition: AVCaptureDevice.Position = (self.currentPosition == .front) ? .back : .front
            
            // Remove old input
            if let oldInput = self.session.inputs.first {
                self.session.removeInput(oldInput)
            }
            
            // Add new input
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: newDevice),
                  self.session.canAddInput(newInput) else { return }
            
            self.session.addInput(newInput)
            
            if wasRunning { self.session.startRunning() }
            
            // ✅ Update @Published property on main thread
            DispatchQueue.main.async {
                self.currentPosition = newPosition
                NotificationCenter.default.post(name: .cameraDidSwitch, object: newPosition)
            }
        }
    }
    
    // MARK: - Capture photo
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func capture4Shots(count: Int, delay: Double = 3) {
        capturedImages = []
        func takeShot(index: Int) {
            if index >= count { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.capturePhoto()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let img = self.capturedImage {
                        self.capturedImages.append(img)
                    }
                    takeShot(index: index + 1)
                }
            }
        }
        takeShot(index: 0)
    }
    
    // MARK: - Permission
    func checkCameraPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startSessionSafely()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.startSessionSafely() }
            }
        default:
            print("Camera access denied")
        }
    }
}

// MARK: - Photo capture delegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        
        var finalImage = image
        
        // Mirror front camera
        if let input = session.inputs.first as? AVCaptureDeviceInput,
           input.device.position == .front {
            finalImage = UIImage(cgImage: image.cgImage!,
                                 scale: image.scale,
                                 orientation: .leftMirrored)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = finalImage
        }
    }
}

// MARK: - Camera Preview
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var manager: CameraManager
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.configure(session: manager.session, position: manager.currentPosition)
        
        NotificationCenter.default.addObserver(forName: .cameraDidSwitch,
                                               object: nil,
                                               queue: .main) { notification in
            if let pos = notification.object as? AVCaptureDevice.Position {
                view.configure(session: manager.session, position: pos)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {}
}

// MARK: - Preview View
final class PreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    
    private var videoLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    
    func configure(session: AVCaptureSession, position: AVCaptureDevice.Position) {
        videoLayer.session = session
        videoLayer.videoGravity = .resizeAspectFill
        
        if let connection = videoLayer.connection {
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = (position == .front)
            }
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = bounds
    }
}

// MARK: - Notification
extension Notification.Name {
    static let cameraDidSwitch = Notification.Name("cameraDidSwitch")
}
