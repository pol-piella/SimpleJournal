//
//  ViewController.swift
//  SimpleJournalApp
//
//  Created by Pol Piella Abadia on 08/04/2022.
//

import UIKit
import CameraService

class ShutterButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = isHighlighted ? .white.withAlphaComponent(0.7) : .white
        layer.cornerRadius = frame.width / 2.0
    }
}

class CameraViewController: UIViewController, CameraView {
    let viewModel: ViewModel
    var layer: CALayer?
    
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cameraView: UIView = {
        let view = UIView()
        view.isAccessibilityElement = false
        view.translatesAutoresizingMaskIntoConstraints = false
        let gestureRecogniser = UITapGestureRecognizer()
        gestureRecogniser.numberOfTapsRequired = 2
        gestureRecogniser.addTarget(self, action: #selector(didDoubleTap))
        view.addGestureRecognizer(gestureRecogniser)
        return view
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        view.isAccessibilityElement = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var shutterButton: UIButton = {
        let button = ShutterButton(primaryAction: UIAction(handler: { _ in
            self.viewModel.didPressShutter()
        }))
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { _ in
            self.viewModel.didDiscardImage()
        }))
        button.setBackgroundImage(UIImage(systemName: "xmark")!, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    lazy var rotateButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { _ in
            self.viewModel.didDoubleTap()
        }))
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .white.withAlphaComponent(0.3)
        configuration.imagePadding = 5
        configuration.image = UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill")!
            .withRenderingMode(.alwaysTemplate)
        configuration.imageColorTransformer = .init({ _ in .black })
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { _ in
            self.viewModel.didTapNext()
        }))
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .white
        configuration.imagePadding = 5
        configuration.image = UIImage(systemName: "arrow.forward")!
            .withRenderingMode(.alwaysTemplate)
        configuration.imageColorTransformer = .init({ _ in .black })
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    func animateShutter() {
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        layer?.frame = cameraView.frame
        layer?.backgroundColor = UIColor.red.cgColor
        layer?.cornerRadius = 40
    }
    
    func updateLayer(_ layer: CALayer) {
        self.layer = layer
        self.cameraView.layer.addSublayer(layer)
    }
    
    
    @objc func didDoubleTap() {
        viewModel.didDoubleTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateState(.taking)
        
        bottomBarView.addSubview(shutterButton)
        bottomBarView.addSubview(rotateButton)
        bottomBarView.addSubview(nextButton)
        
        view.addSubview(cameraView)
        view.addSubview(closeButton)
        view.addSubview(bottomBarView)
        
        NSLayoutConstraint.activate([
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: -8),
            // Bottom Bar View
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 100),
            // Shutter Button
            shutterButton.widthAnchor.constraint(equalToConstant: 70),
            shutterButton.heightAnchor.constraint(equalTo: shutterButton.widthAnchor),
            shutterButton.centerXAnchor.constraint(equalTo: bottomBarView.centerXAnchor),
            shutterButton.topAnchor.constraint(greaterThanOrEqualTo: bottomBarView.topAnchor),
            shutterButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomBarView.bottomAnchor),
            shutterButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            // Close Button
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            // Rotate Button
            rotateButton.widthAnchor.constraint(equalToConstant: 44),
            rotateButton.heightAnchor.constraint(equalTo: rotateButton.widthAnchor),
            rotateButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            rotateButton.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            // Next Button
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor),
            nextButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16)
        ])
        
        viewModel.loadCamera()
    }
    
    func updateState(_ state: ViewModel.State) {
        nextButton.isHidden = state == .taking
        rotateButton.isHidden = state == .taken
        closeButton.isHidden = state == .taking
    }
}

