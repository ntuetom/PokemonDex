//
//  integrationDataService.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/3.
//

import RxSwift

class IntegrationDataService: PokemonAttributeProtocol, PokemonSpeciesProtocol, PokemonGeneralProtocol {
    
    private let localService = LocalService()
    private let networkService = NetworkService()
    private let dataBase = DatabaseService.instance
    
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse,ParseResponseError>> {
        return networkService.fetchPokemonList(offset: offset, limit: limit)
    }
    
    func fetchPokemonDetail(url: String) -> Observable<Result<PokemonDetailResponse,ParseResponseError>> {
        return networkService.fetchPokemonDetail(url: url)
    }
    func fetchPokemonDetailByKey(key: String) ->
    Single<Result<PokemonDetailResponse,ParseResponseError>> {
        return networkService.fetchPokemonDetailByKey(key: key)
    }
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse,ParseResponseError>> {
        return networkService.fetchSpecies(url: url)
    }
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse,ParseResponseError>> {
        return networkService.fetchEvolution(url: url)
    }
    
    func fetchPokemonDetailCombine(offset: Int, limit: Int) -> Observable<(detail: Result<PokemonDetailResponse,ParseResponseError>, count: Int)>? {
        if offset == 0 && localService.fetchDBPokemonDetailExist() {
            return localService.fetchPokemonDetail(url: "").map{($0,1302)}
        }
        return networkService.fetchPokemonList(offset: offset, limit: limit)
            .map{ response -> (basics: [BasicType], count: Int) in
                do {
                    let data = try response.get()
                    return (data.results,data.count)
                }catch {
                    print(error)
                    return ([],0)
                }}
            .asObservable()
            .flatMap{ data in
                Observable.from(data.basics.map{($0,data.count)})
            }
            .flatMap{[weak self] response -> Observable<(detail: Result<PokemonDetailResponse,ParseResponseError>, count: Int)> in
                guard let self = self else {return Observable.empty()}
                return self.networkService.fetchPokemonDetail(url: response.0.url).map{(detail: $0, count: response.1)}
            }
    }
}
