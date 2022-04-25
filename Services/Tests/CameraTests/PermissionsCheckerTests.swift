import XCTest
@testable import Camera
import AVFoundation

class SpySystemInteractor: SystemInteractor {
    let status: AVAuthorizationStatus
    
    var requestAccessCallCount = 0
    
    init(_ status: AVAuthorizationStatus) {
        self.status = status
    }
    
    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        status
    }
    
    func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void) {
        requestAccessCallCount += 1
        handler(true)
    }
}

class PermissionsCheckerTests: XCTestCase {
    func test_WhenPermissionCheckFails_ThenCompletionReturnsADeniedState() {
        let spyInteractor = SpySystemInteractor(.denied)
        let cameraPermissionsChecker = DeviceCameraPermissions(systemInteractor: spyInteractor)
        
        cameraPermissionsChecker.check { XCTAssertEqual($0, .denied) }
    }
}
