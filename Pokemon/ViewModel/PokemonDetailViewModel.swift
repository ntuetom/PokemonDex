//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import RxCocoa
import RxSwift
import CoreGraphics

class PokemonDetailViewModel: BaseViewModel {
    
    let pokemonBasicData: PokemonCellData
    let evoChainDataSource = BehaviorRelay<[PokemonEvoSectionDataType]>(value: [])
    let speciesInfoEvent = PublishSubject<PokemonSpeciesResponse>()
    let didClickCellEvent = PublishSubject<PokemonCellData>()
    private(set) weak var saveBtnEvent: PublishSubject<PokemonCellData>?
    private(set) var isSaved: Bool
    private let service: PokemonService
    
    init(data: PokemonCellData, saveBtnEvent: PublishSubject<PokemonCellData>? = nil, service: PokemonService = IntegrationDataService()) {
        self.pokemonBasicData = data
        self.isSaved = data.isSaved
        self.saveBtnEvent = saveBtnEvent
        self.service = service
    }
    
    func updateEvoDataStore(_ data: PokemonEvoData) {
        if data.color != nil {
            DatabaseService.instance.update(qId: data.id, model: data)
        }
    }
    
    func getSpecies() {
        service
            .fetchPokemonEvoCombine(id: pokemonBasicData.id, speciesUrl: pokemonBasicData.species.url)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {return}
                response.forEach{
                    if !$0.isLocalData {
                        self.updateEvoDataStore($0.data)
                    }
                }
                if let firstData = response.filter({$0.data.id == self.pokemonBasicData.id}).first, let color = firstData.data.color {
                    let sameIdData = firstData.data
                    let speciesData = PokemonSpeciesResponse(evolutionChain: ["url": ""], formDescriptions: sameIdData.formDescriptions ?? [], color: BasicType(name: color, url: ""), name: sameIdData.name, id: sameIdData.id)
                    self.speciesInfoEvent.onNext(speciesData)
                }
                self.evoChainDataSource.accept(self.handleSection(response.map{$0.data}))
            })
            .disposed(by: disposeBag)
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
