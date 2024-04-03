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
        
        viewModel.didClickCellEvent.subscribe(onNext: { [weak self] cellData in
            guard let self = self else {return}
            let detailCoordinator = PokemonDetailCoordinator(navigationController: self.navigationController, data: cellData, saveBtnEvent: self.viewModel.saveBtnEvent)
            self.start(coordinator: detailCoordinator)
        }).disposed(by: disposeBag)
    }
}
