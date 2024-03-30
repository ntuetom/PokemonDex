//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        coordinator = AppCoordinator(window: window!)
        coordinator?.start()
        
        return true
    }


}

