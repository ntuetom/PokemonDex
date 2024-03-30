//
//  PokemonServiceProtocol.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxSwift

protocol PokemonServiceProtocol {
    func fetchPokemonList() -> Single<Result<FetchPokemonListResponse,ParseResponseError>>
    func fetchPokemonDetail(url: String) -> Single<Result<PokemonDetailResponse,ParseResponseError>>
}

extension PokemonServiceProtocol {
    func fetchPokemonList() -> Single<Result<FetchPokemonListResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonList)
    }
    
    func fetchPokemonDetail(url: String) -> Single<Result<PokemonDetailResponse,ParseResponseError>> {
        return requestShared.request(target: .fetchPokemonDetail(url: url))
    }
}
