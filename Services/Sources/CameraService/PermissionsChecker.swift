import AVFoundation

public protocol PermissionsChecker {
    func check(_ completion: @escaping (DeviceCameraStatus) -> Void)
}

public enum DeviceCameraStatus {
    case denied
    case granted
}

public protocol SystemInteractor {
    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void)
}

public class DeviceCameraPermissions: PermissionsChecker {
    let systemInteractor: SystemInteractor
    
    public init(systemInteractor: SystemInteractor) {
        self.systemInteractor = systemInteractor
    }
    
    public func check(_ completion: @escaping (DeviceCameraStatus) -> Void) {
        switch systemInteractor.authorizationStatus(for: .video) {
        case .authorized: completion(.granted)
        case .notDetermined: systemInteractor.requestAccess(for: .video) { completion($0 ? .granted : .denied) }
        default: completion(.denied)
        }
    }
}
