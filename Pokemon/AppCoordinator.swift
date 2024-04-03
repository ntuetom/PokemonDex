//
//  AppCoordinator.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        DatabaseService.instance.initialize()
        
        let coordinator = PokeListCoordinator(navigationController: navigationController)
        start(coordinator: coordinator)
        
        if #available(iOS 14.0, *) {
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = UIColor.white
            UITableViewHeaderFooterView.appearance().backgroundConfiguration = bgConfig
        }
    }
}
