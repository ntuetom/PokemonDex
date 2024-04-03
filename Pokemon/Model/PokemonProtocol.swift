//
//  PokemonServiceProtocol.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxSwift

typealias PokemonService = PokemonAttributeProtocol & PokemonSpeciesProtocol & PokemonGeneralProtocol
protocol PokemonGeneralProtocol {
    func fetchPokemonDetailCombine(offset: Int, limit: Int) -> Observable<(detail: Result<PokemonDetailResponse,ParseResponseError>, count: Int)>?
}
extension PokemonGeneralProtocol {
    func fetchPokemonDetailCombine(offset: Int, limit: Int) -> Observable<(detail: Result<PokemonDetailResponse,ParseResponseError>, count: Int)>? {
        return nil
    }
}
protocol PokemonAttributeProtocol {
    func fetchPokemonList(offset: Int, limit: Int) -> Single<Result<FetchPokemonListResponse,ParseResponseError>>
    func fetchPokemonDetail(url: String) -> Observable<Result<PokemonDetailResponse,ParseResponseError>>
    func fetchPokemonDetailByKey(key: String) -> Single<Result<PokemonDetailResponse,ParseResponseError>>
}

protocol PokemonSpeciesProtocol {
    func fetchSpecies(url: String) -> Single<Result<PokemonSpeciesResponse,ParseResponseError>>
    func fetchEvolution(url: String) -> Single<Result<EvolutionResponse,ParseResponseError>>
}


