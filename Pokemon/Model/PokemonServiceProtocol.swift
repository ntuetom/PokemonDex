//
//  PokemonServiceProtocol.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxSwift

protocol PokemonAttributeProtocol {
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse,ParseResponseError>>
    func fetchPokemonDetail(url: String) -> Single<Result<PokemonDetailResponse,ParseResponseError>>
}

extension PokemonAttributeProtocol {
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonList(offset: offset, limit: limit))
    }
    
    func fetchPokemonDetail(url: String) -> Single<Result<PokemonDetailResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonDetail(url: url))
    }
}

protocol PokemonSpeciesProtocol {
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse,ParseResponseError>>
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse,ParseResponseError>>
}

extension PokemonSpeciesProtocol {
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonSpecies(url: url))
    }
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchEvolutionChain(url: url))
    }
}


