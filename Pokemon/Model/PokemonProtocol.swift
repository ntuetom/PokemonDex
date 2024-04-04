//
//  PokemonServiceProtocol.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxSwift

typealias PokemonService = PokemonAttributeProtocol & PokemonSpeciesProtocol & PokemonGeneralProtocol
typealias LocalProtocol = LocalPersistProtocol & PokemonAttributeProtocol

protocol LocalPersistProtocol {
    func fetchLocalPokemonBy(id: Int) -> PokemonCellData?
    func fetchPokemonEvoDetail(id: Int) -> [String]?
    func fetchDBPokemonDetailExist() -> Bool
    func fetchPokemonEvoDataByKey(key: String) -> Single<Result<PokemonCellData, ParseResponseError>>
}

protocol PokemonGeneralProtocol {
    func fetchPokemonDetailCombine(offset: Int, limit: Int) -> Observable<(detail: Result<PokemonDetailResponse,ParseResponseError>, count: Int)>
    func fetchPokemonEvoCombine(id: Int, speciesUrl: String) -> Single<[Result<(evoData: PokemonEvoData, isLocalData: Bool),ParseResponseError>]>
    func localFetchPokemonCellData(id: Int) -> PokemonCellData?
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


