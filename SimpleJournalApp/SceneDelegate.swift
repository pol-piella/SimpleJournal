//
//  SceneDelegate.swift
//  SimpleJournalApp
//
//  Created by Pol Piella Abadia on 08/04/2022.
//

import UIKit
import Capture

class HelloRouter: Router {
    func navigate(withPhoto photo: UIImage) {
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = Factory.make(router: HelloRouter())
        window.makeKeyAndVisible()
        self.window = window
    }
}

