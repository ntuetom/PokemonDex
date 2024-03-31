//
//  PokeListCoordinator.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation

class PokeListCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = PokemonListViewModel()
        let vc = PokemonListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
        
        viewModel.didClickCell.subscribe(onNext: { [weak self] cellData in
            guard let self = self else {return}
            let detailCoordinator = PokemonDetailCoordinator(navigationController: self.navigationController, data: cellData)
            self.start(coordinator: detailCoordinator)
        }).disposed(by: disposeBag)
    }
}
