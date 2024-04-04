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
    private let dbService: DataBaseProtocol
    
    init(data: PokemonCellData, saveBtnEvent: PublishSubject<PokemonCellData>? = nil, service: PokemonService = IntegrationDataService(), dbService: DataBaseProtocol = DatabaseService.instance) {
        self.pokemonBasicData = data
        self.isSaved = data.isSaved
        self.saveBtnEvent = saveBtnEvent
        self.service = service
        self.dbService = dbService
    }
    
    deinit {
        print("PokemonDetailViewModel deinit")
    }
    
    func updateEvoDataStore(_ data: PokemonEvoData) {
        dbService.update(qId: data.id, model: data)
    }
    
    func getSpeciesToNext(evoData: PokemonEvoData) -> PokemonCellData {
        if let data = service.localFetchPokemonCellData(id: evoData.id) {
            return data
        }
        return PokemonCellData(name: evoData.name, id: evoData.id, imageUrl: evoData.imageUrl, types: evoData.types.map{$0.type.name}, species: evoData.species, isSaved: false)
    }
    
    func getSpecies() {
        service
            .fetchPokemonEvoCombine(id: pokemonBasicData.id, speciesUrl: pokemonBasicData.species.url)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {return}
                var succesData: [PokemonEvoData] = []
                response.forEach { responseData in
                    switch responseData {
                    case .success(let data):
                        if !data.isLocalData {
                            self.updateEvoDataStore(data.evoData)
                        }
                        if data.evoData.id == self.pokemonBasicData.id, let color = data.evoData.color {
                            let speciesData = PokemonSpeciesResponse(evolutionChain: ["url": ""], formDescriptions: data.evoData.formDescriptions ?? [], color: BasicType(name: color, url: ""), name: data.evoData.name, id: data.evoData.id)
                            self.speciesInfoEvent.onNext(speciesData)
                        }
                        succesData.append(data.evoData)
                    case .failure(let error):
                        let unSavedKey = error.code
                        self.service.fetchPokemonDetailByKey(key: unSavedKey).subscribe(onSuccess: { detailResponseData in
                            switch detailResponseData {
                            case .success(let detail):
                                let evoData = PokemonEvoData(name: detail.name, imageUrl: detail.sprites.frontDefault, id: detail.id, types: detail.types, temp: PokemonEvoTemp(species: detail.species, order: 0, evolutionDetails: []), isSaved: false)
                                succesData.append(evoData)
                                self.evoChainDataSource.accept(self.handleSection(succesData))
                            case .failure(let error):
                                print(error)
                            }
                        }).disposed(by: self.disposeBag)
                    }
                }
                self.evoChainDataSource.accept(self.handleSection(succesData))
            })
            .disposed(by: disposeBag)
    }
    
    func handleSection(_ data: [PokemonEvoData]) -> [PokemonEvoSectionDataType]{
        var result: [PokemonEvoSectionDataType] = []
        for item in data {
            let order = item.order ?? 0
            if let _first = result.filter({$0.model == "\(order)"}).first {
                var items = _first.items
                items.append(item)
                result[order] = PokemonEvoSectionDataType(model: "\(order)", items: items)
            } else {
                result.append(PokemonEvoSectionDataType(model: "\(order)", items: [item]))
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
