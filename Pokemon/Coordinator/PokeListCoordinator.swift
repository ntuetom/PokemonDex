//
//  PokeListCoordinator.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation

class PokeListCoordinator: BaseCoordinator {
    
    override func start() {
        let vc = PokemonListViewController(viewModel: PokemonListViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
}
