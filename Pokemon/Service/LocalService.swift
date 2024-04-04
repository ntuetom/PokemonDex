//
//  LocalService.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/3.
//

import RxSwift

class LocalService: PokemonAttributeProtocol, PokemonSpeciesProtocol {
    private let dataBase = DatabaseService.instance
    private var localPokemonDetail: [PokemonCellData]?
    
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse, ParseResponseError>> {
        let chainData = ChainData(evolutionDetails: [], evolvesTo: [], isBaby: false, species: BasicType(name: "", url: ""))
        return Single.create { single -> Disposable in
            single(.success(.success(EvolutionResponse(chain: chainData, id: 1))))
            return Disposables.create()
        }
    }
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse, ParseResponseError>> {
        return Single.create { single -> Disposable in
            single(.success(.success(PokemonSpeciesResponse(evolutionChain: [:], formDescriptions: [], color: BasicType(name: "", url: ""), name: "", id: 1))))
            return Disposables.create()
        }
    }
    func fetchPokemonDetail(url: String) -> Observable<Result<PokemonDetailResponse, ParseResponseError>> {
        
        return Observable.create { [weak self] observer -> Disposable in
            if let persistantData = self?.localPokemonDetail {
                persistantData.forEach {
                    let types = $0.types.map{ PokemonType(slot: 0, type: BasicType(name: $0, url: ""))}
                    observer.onNext (.success(PokemonDetailResponse(id: $0.id, name: $0.name, sprites: Sprites(frontDefault: $0.imageUrl), types: types, species: $0.species, isSave: $0.isSaved)))
                }
                observer.onCompleted()
            } else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    func fetchPokemonDetailByKey(key: String) -> Single<Result<PokemonDetailResponse, ParseResponseError>> {
       
        return Single.create { [weak self] single -> Disposable in
            if let self = self, let id = Int(key), let pokemonDetail = self.dataBase.queryBy(id: id) {
                single(.success(.success(
                    PokemonDetailResponse(
                        id: pokemonDetail.id,
                        name: pokemonDetail.name,
                        sprites: Sprites(frontDefault: pokemonDetail.imageUrl),
                        types: pokemonDetail.types.map{
                            PokemonType(slot: 0, type: BasicType(name: $0, url: ""))},
                        species: pokemonDetail.species,
                        isSave: pokemonDetail.isSaved))))
            } else {
                single(.success(.failure(ParseResponseError.parseError(errMsg: "localService fetchPokemonDetailByKey single error"))))
            }
            
            return Disposables.create()
        }
    }
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse, ParseResponseError>> {
        return Single.create { single -> Disposable in
            single(.success(.success(FetchPokemonListResponse(count: 0, previous: nil, next: nil, results: []))))
            return Disposables.create()
        }
    }
    
    func fetchPokemonEvoDataByKey(key: String) -> Single<Result<PokemonCellData, ParseResponseError>> {
       
        return Single.create { [weak self] single -> Disposable in
            if let self = self, let id = Int(key), let pokemonDetail = self.dataBase.queryBy(id: id) {
                single(.success(.success(
                    pokemonDetail)))
            } else {
                single(.success(.failure(ParseResponseError.parseError(errMsg: "localService fetchPokemonDetailByKey single error"))))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchDBPokemonDetailExist() -> Bool {
        localPokemonDetail = dataBase.query()
        return localPokemonDetail?.count ?? 0 > 0
    }
    
    func fetchPokemonEvoDetail(id: Int) -> [String]? {
        if let pokemonDetail = dataBase.queryBy(id: id) {
            if let evoChain = pokemonDetail.evoChain, pokemonDetail.color != nil {
                return evoChain.split(separator: ",").map{String($0)}
            }
        }
        return nil
    }
}
