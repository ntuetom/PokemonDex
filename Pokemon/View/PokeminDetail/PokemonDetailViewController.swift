//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    private var viewModel: PokemonDetailViewModel!
    private var contentView: PokemonDetailView!
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.contentView = PokemonDetailView(owner: self)
        title = viewModel.pokeName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        contentView.setup(url: viewModel.pokemonData.url)
    }
    
    func initializeData() {
        viewModel.getSpecies()
    }
}
