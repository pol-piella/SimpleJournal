import CameraService
import UIKit

protocol CameraView: AnyObject {
    func animateShutter()
    func updateLayer(_ layer: CALayer)
    func updateState(_ state: ViewModel.State)
}

protocol CameraInterface {
    var layer: CALayer { get }
    
    func rotate()
    func start()
    func capture(_ completion: @escaping (UIImage?) -> Void)
}

class ViewModel {
    enum State {
        case taking
        case taken
    }
    
    let feedback: Feedback
    let router: Router
    var camera: CameraInterface?
    var image: UIImage? {
        didSet {
            view?.updateState(image == nil ? .taking : .taken)
        }
    }
    
    weak var view: CameraView?
    
    init(feedback: Feedback, router: Router) {
        self.feedback = feedback
        self.router = router
    }
    
    func loadCamera() {
        CameraProvider.camera { [weak self] result in
            switch result {
            case let .success(camera):
                self?.camera = camera
                self?.camera?.start()
                self?.view?.updateLayer(camera.layer)
            case .failure: break
            }
        }
    }
    
    func didDoubleTap() {
        feedback.perform()
        camera?.rotate()
    }
    
    func didPressShutter() {
        view?.animateShutter()
        camera?.capture { self.image = $0 }
    }
    
    func didDiscardImage() {
        image = nil
        camera?.start()
    }
    
    func didTapNext() {
        router.navigate(withPhoto: image!)
    }
}
