//
//  BaseCoordinator.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation
import UIKit
import RxSwift

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
}

class BaseCoordinator: Coordinator {
    var disposeBag = DisposeBag()
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit{
        print("BaseCoordinator deinit")
        disposeBag = DisposeBag()
    }
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
            if let last = navigationController.children.last, let vc = last as? PokemonDetailViewController {
                navigationController.delegate = vc
            }
        }
    }
}
