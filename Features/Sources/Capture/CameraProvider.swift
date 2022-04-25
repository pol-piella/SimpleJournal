import CameraService

extension CameraService.Camera: CameraInterface {}

enum CameraProvider {
    enum CameraError: Error {
        case permissionsFailure
    }
    
    static func camera(_ completion: @escaping (Result<CameraInterface, CameraError>) -> Void) {
        CameraService.Factory()
            .make {
                completion(
                    $0
                        .map { $0 as CameraInterface }
                        .mapError { _ in CameraError.permissionsFailure }
                )
            }
    }
}
