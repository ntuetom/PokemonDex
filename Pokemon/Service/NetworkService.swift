//
//  NetworkService.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/3.
//

import RxSwift

class NetworkService: PokemonAttributeProtocol, PokemonSpeciesProtocol, PokemonGeneralProtocol {
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonList(offset: offset, limit: limit))
    }
    
    func fetchPokemonDetail(url: String) -> Observable<Result<PokemonDetailResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonDetail(url: url)).asObservable()
    }
    func fetchPokemonDetailByKey(key: String) ->
    Single<Result<PokemonDetailResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonDetailByKey(key: key))
    }
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonSpecies(url: url))
    }
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchEvolutionChain(url: url))
    }
}
