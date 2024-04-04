//
//  File.swift
//  PokemonTests
//
//  Created by Wu hung-yi on 2024/4/5.
//

import RxSwift
@testable import Pokemon

class MockService: PokemonService {
    var testData: (detail: Result<PokemonDetailResponse, ParseResponseError>, count: Int)!
    
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse, ParseResponseError>> {
        return Single.create {_ in
            return Disposables.create()
        }
    }
    
    func fetchPokemonDetail(url: String) -> Observable<Result<PokemonDetailResponse, ParseResponseError>> {
        return Observable.create {_ in
            return Disposables.create()
        }
    }
    
    func fetchPokemonDetailByKey(key: String) -> Single<Result<PokemonDetailResponse, ParseResponseError>> {
        return Single.create {_ in
            return Disposables.create()
        }
    }
    
    func fetchPokemonDetailCombine(offset: Int, limit: Int) -> Observable<(detail: Result<PokemonDetailResponse, ParseResponseError>, count: Int)> {
        return Observable.create {[weak self]observer in
            observer.onNext(self!.testData)
            return Disposables.create()
        }
    }
    
    func fetchPokemonEvoCombine(id: Int, speciesUrl: String) -> Single<[Result<(evoData: PokemonEvoData, isLocalData: Bool), ParseResponseError>]> {
        return Single.create {_ in
            return Disposables.create()
        }
    }
    
    func localFetchPokemonCellData(id: Int) -> PokemonCellData? {
        nil
    }
    
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse, ParseResponseError>> {
        return Single.create {_ in
            return Disposables.create()
        }
    }
    
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse, ParseResponseError>> {
        return Single.create {_ in
            return Disposables.create()
        }
    }
}

class MockDatabase: DataBaseProtocol {
    func initialize() {
        
    }
    
    func createTable() {
        
    }
    
    func insert(models: [PokemonCellData]) {
        
    }
    
    func query() -> [PokemonCellData]? {
        nil
    }
    
    func queryBy(id: Int) -> PokemonCellData? {
        nil
    }
    
    func update(qId: Int, model: PokemonCellData) {
            
    }
    
    func update(qId: Int, model: PokemonEvoData) {
        
    }
    
    
}
