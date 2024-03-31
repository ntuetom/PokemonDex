//
//  PokemonDetailCoordinator.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import UIKit

class PokemonDetailCoordinator: BaseCoordinator {
    
    let viewModel: PokemonDetailViewModel
    
    init(navigationController: UINavigationController, data: PokemonCellData) {
        viewModel = PokemonDetailViewModel(data: data)
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let vc = PokemonDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
