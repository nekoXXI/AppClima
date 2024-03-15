//
//  SceneDelegate.swift
//  AppClima
//
//  Created by Адиль on 13/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigation = UINavigationController(rootViewController: WeatherViewController())
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        }
}

