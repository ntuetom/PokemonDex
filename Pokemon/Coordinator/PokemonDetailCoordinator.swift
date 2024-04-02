//
//  PokemonDetailCoordinator.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import UIKit
import RxSwift

class PokemonDetailCoordinator: BaseCoordinator {
    
    let viewModel: PokemonDetailViewModel
    
    init(navigationController: UINavigationController, data: PokemonCellData, saveBtnEvent: PublishSubject<PokemonCellData>? = nil) {
        viewModel = PokemonDetailViewModel(data: data, saveBtnEvent: saveBtnEvent)
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let vc = PokemonDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
        
        viewModel.didClickCellEvent.subscribe(onNext: { [weak self] evoData in
            guard let self = self else {return}
            let cellData = PokemonCellData(name: evoData.name, id: evoData.id, imageUrl: evoData.imageUrl, types: evoData.types.map{$0.type.name}, species: evoData.species)
            let detailCoordinator = PokemonDetailCoordinator(navigationController: self.navigationController, data: cellData)
            self.start(coordinator: detailCoordinator)
        }).disposed(by: disposeBag)
    }
}
