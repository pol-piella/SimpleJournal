import UIKit

public enum Factory {
    public static func make(router: Router) -> UIViewController {
        let viewModel = ViewModel(feedback: Haptic(), router: router)
        
        let viewController = CameraViewController(viewModel)
        viewModel.view = viewController
        
        return viewController
    }
}
