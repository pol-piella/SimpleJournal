import CameraService
import UIKit

protocol FeedbackGenerator {
    func generate()
}

protocol CameraView: AnyObject {
    func animateShutter()
    func updateLayer(_ layer: CALayer)
    func updateState(_ state: ViewModel.State)
}

class ViewModel {
    enum State {
        case taking
        case taken
    }
    
    let feedbackGenerator: FeedbackGenerator
    let router: Router
    var camera: Camera?
    var image: UIImage? {
        didSet {
            view?.updateState(image == nil ? .taking : .taken)
        }
    }
    
    weak var view: CameraView?
    
    init(feedbackGenerator: FeedbackGenerator, router: Router) {
        self.feedbackGenerator = feedbackGenerator
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
        feedbackGenerator.generate()
        camera?.rotate()
    }
    
    func didPressShutter() {
        view?.animateShutter()
        self.camera?.capture { self.image = $0 }
    }
    
    func didDiscardImage() {
        image = nil
        camera?.start()
    }
    
    func didTapNext() {
        router.navigate(withPhoto: image!)
    }
}
