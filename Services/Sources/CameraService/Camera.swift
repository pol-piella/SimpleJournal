import UIKit
import AVFoundation

public class Camera: NSObject, AVCapturePhotoCaptureDelegate {
    let session: AVCaptureSession
    var output = AVCapturePhotoOutput()
    var photoBlock: ((UIImage?) -> Void)?
    var currentInput: AVCaptureDeviceInput
    
    // Clients can use this.
    let videoLayer: AVCaptureVideoPreviewLayer
    public var layer: CALayer {
        videoLayer
    }
    
    public override init() {
        session = AVCaptureSession()
        session.beginConfiguration()
        let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        self.currentInput = try! AVCaptureDeviceInput(device: device!)
        if session.canAddInput(currentInput) { session.addInput(currentInput) }
        if session.canAddOutput(output) { session.addOutput(output) }
        session.commitConfiguration()
        videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer.videoGravity = .resizeAspectFill
        super.init()
    }
    
    public func start() {
        if !session.isRunning { session.startRunning() }
        videoLayer.connection?.isEnabled = true
    }
    
    public func stop() {
        if session.isRunning { session.stopRunning() }
    }

    
    public func capture(_ completion: @escaping (UIImage?) -> Void) {
        self.photoBlock = completion
        self.output.capturePhoto(with: .init(), delegate: self)
        videoLayer.connection?.isEnabled = false
    }
    
    public func rotate() {
        let currentPosition = self.currentInput.device.position
        
        let backCameraDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera],
                                                                                mediaType: .video, position: .back)
        let frontDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInWideAngleCamera],
                                                                                mediaType: .video, position: .front)
        var newVideoDevice: AVCaptureDevice? = nil
        
        switch currentPosition {
        case .unspecified, .front:
            newVideoDevice = backCameraDeviceDiscoverySession.devices.first
            
        case .back:
            newVideoDevice = frontDeviceDiscoverySession.devices.first
            
        @unknown default:
            newVideoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        }
        
        session.beginConfiguration()
        
        if let newVideoDevice = newVideoDevice {
            session.removeInput(currentInput)
            
            let input = try! AVCaptureDeviceInput(device: newVideoDevice)
            if session.canAddInput(input) {
                session.addInput(input)
                self.currentInput = input
            }
        }
        
        session.commitConfiguration()

    }
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), error == nil, let image = UIImage(data: data) else {
            photoBlock?(nil)
            return
        }
        photoBlock?(image)
    }
}
