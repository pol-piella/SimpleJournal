import AVFoundation

public class Factory {
    public enum FactoryError: Error {
        case permissionDenied
        case cameraUnavailable
    }
    
    let permissionsChecker: PermissionsChecker
    
    public init() {
        let systemInteractor = CaptureDeviceWrapper()
        permissionsChecker = DeviceCameraPermissions(systemInteractor: systemInteractor)
    }
    
    public func make(_ completion: @escaping (Result<Camera, FactoryError>) -> Void) {
        permissionsChecker.check { outcome in
            switch outcome {
            case .denied: completion(.failure(.permissionDenied))
            case .granted: completion(.success(Camera()))
            }
        }
    }
}

class CaptureDeviceWrapper: SystemInteractor {
    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: mediaType, completionHandler: handler)
    }
    
}
