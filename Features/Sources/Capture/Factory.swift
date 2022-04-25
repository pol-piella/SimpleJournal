import UIKit
import CameraService

public protocol Router {
    func navigate(withPhoto photo: UIImage)
}

class HapticGenerator: FeedbackGenerator {
    let generator = UIFeedbackGenerator()
    
    func generate() {
        generator.prepare()
    }
}

enum CameraProvider {
    enum CameraError: Error {
        case permissionsFailure
    }
    
    static func camera(_ completion: @escaping (Result<Camera, CameraError>) -> Void) {
        CameraService.Factory()
            .make { completion($0.mapError({ _ in CameraError.permissionsFailure })) }
    }
}

public enum Factory {
    public static func make(router: Router) -> UIViewController {
        let viewModel = ViewModel(
            feedbackGenerator: HapticGenerator(),
            router: router
        )
        
        let viewController = CameraViewController(viewModel)
        viewModel.view = viewController
        
        return viewController
    }
}
