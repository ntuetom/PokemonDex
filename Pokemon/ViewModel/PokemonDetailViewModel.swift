//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import RxCocoa
import RxSwift
import CoreGraphics

class PokemonDetailViewModel: BaseViewModel,PokemonSpeciesProtocol, PokemonAttributeProtocol {
    
    let pokemonBasicData: PokemonCellData
    let evoChainDataSource = BehaviorRelay<[PokemonEvoSectionDataType]>(value: [])
    let speciesInfoEvent = PublishSubject<PokemonSpeciesResponse>()
    let didClickCellEvent = PublishSubject<PokemonEvoData>()
    private weak var saveBtnEvent: PublishSubject<PokemonCellData>?
    private(set) var isSaved: Bool
    
    init(data: PokemonCellData, saveBtnEvent: PublishSubject<PokemonCellData>? = nil) {
        self.pokemonBasicData = data
        self.isSaved = data.isSaved
        self.saveBtnEvent = saveBtnEvent
    }
    
    func getSpecies() {
        fetchSpecies(url: pokemonBasicData.species.url)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map {[unowned self] response -> PokemonSpeciesResponse in
                do {
                    let species = try response.get()
                    self.speciesInfoEvent.onNext(species)
                    return species
                } catch let error {
                    throw error
                }
            }
            .flatMap{[unowned self] species in
                return self.fetchEvolution(url: species.evolutionChain["url"]!)
            }
            .map{ [unowned self] response -> [PokemonEvoTemp] in
                do {
                    let evo = try response.get()
                    let chains = self.handleEvoChain(evo.chain, order: 0)
                    return chains
                } catch let error {
                    throw error
                }
            }
            .flatMap { evos in
                Single.zip(evos.map{Single.zip(self.fetchPokemonDetailByKey(key: $0.species.name),Single.just($0))})
            }
            .subscribe(onSuccess: {[unowned self] response in
                do {
                    let data = try response.map{ res -> PokemonEvoData in
                        let detail = res.0
                        let evoTemp = res.1
                        switch detail {
                        case .success(let data):
                            return PokemonEvoData(name: data.name, imageUrl: data.sprites.frontDefault, id: data.id, types: data.types, temp: evoTemp)
                        case .failure(let error):
                            throw error
                        }
                    }
                    self.evoChainDataSource.accept(handleSection(data))
                } catch let error {
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func handleEvoChain(_ chain: ChainData, order: Int) -> [PokemonEvoTemp] {
        var result = [PokemonEvoTemp(species: chain.species, order: order, evolutionDetails: chain.evolutionDetails)]
        if chain.evolvesTo.count > 0 {
            result.append(contentsOf: chain.evolvesTo.flatMap{handleEvoChain($0,order: order+1)})
            return result
        } else {
            return result
        }
    }
    
    func handleSection(_ data: [PokemonEvoData]) -> [PokemonEvoSectionDataType]{
        var result: [PokemonEvoSectionDataType] = []
        for item in data {
            if let _first = result.filter({$0.model == "\(item.order)"}).first {
                var items = _first.items
                items.append(item)
                result[item.order] = PokemonEvoSectionDataType(model: "\(item.order)", items: items)
            } else {
                result.append(PokemonEvoSectionDataType(model: "\(item.order)", items: [item]))
            }
        }
        return result
    }
    
    func setSaveStatus(_ toggle: Bool) {
        isSaved = toggle
        var temp = pokemonBasicData
        temp.isSaved = toggle
        saveBtnEvent?.onNext(temp)
    }
    
    func getCellSize(section: Int) -> CGSize {
        let w = (kScreenW-3*kOffset)/2
        if let model = evoChainDataSource.value.filter({$0.model == "\(section)"}).first {
            if model.items.count == 1 {
                return CGSize(width: kScreenW-2*kOffset, height: w)
            }
        }
        return CGSize(width: w, height: w)
    }
}
