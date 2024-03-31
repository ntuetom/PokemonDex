//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import Foundation
import RxSwift

class PokemonDetailViewModel: PokemonSpeciesProtocol {
    
    let pokemonData: PokemonCellData
    let disposebag = DisposeBag()
    
    var pokeName: String {
        return pokemonData.name
    }
    
    init(data: PokemonCellData) {
        self.pokemonData = data
    }
    
    func getSpecies() {
        fetchSpecies(url: pokemonData.species.url)
            .map {response -> PokemonSpeciesResponse in
                do {
                    let species = try response.get()
                    return species
                } catch let error {
                    throw error
                }
            }
            .flatMap{[unowned self] species in
                self.fetchEvolution(url: species.evolutionChain["url"]!)
            }
            .subscribe(onSuccess: { [unowned self] response in
                switch response {
                case .success(let evo):
                    print(evo)
                case .failure(let error):
                    print(error)
                }
            }, onFailure: {error in
                print(error)
            }).disposed(by: disposebag)
        
        
    }
}
