//
//  integrationDataService.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/3.
//

import RxSwift

class IntegrationDataService: PokemonAttributeProtocol, PokemonSpeciesProtocol, PokemonGeneralProtocol {
    
    private let localService: LocalProtocol = LocalService()
    private let networkService = NetworkService()
    private let userInteractQueue = ConcurrentDispatchQueueScheduler(qos: .userInteractive)
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
    
    func fetchPokemonDetailCombine(offset: Int, limit: Int) -> Observable<(detail: Result<PokemonDetailResponse,ParseResponseError>, count: Int)> {
        if offset == 0 && localService.fetchDBPokemonDetailExist() {
            return localService
                .fetchPokemonDetail(url: "")
                .map{($0,1302)}
                .subscribe(on: userInteractQueue)
        }
        return networkService
            .fetchPokemonList(offset: offset, limit: limit)
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
            .subscribe(on: userInteractQueue)
    }
    
    func fetchPokemonEvoCombine(id: Int, speciesUrl: String) -> Single<([Result<(evoData: PokemonEvoData, isLocalData: Bool),ParseResponseError>])> {
        if let ids = localService.fetchPokemonEvoDetail(id: id) {
            return Single.zip(ids.map{[unowned self] in
                self.localService.fetchPokemonEvoDataByKey(key: $0)
            }).map {
                return $0.map{ detailResponse -> Result<(evoData: PokemonEvoData, isLocalData: Bool),ParseResponseError> in
                    do {
                        let cellData = try detailResponse.get()
                        return Result.success((PokemonEvoData(name: cellData.name,
                                               imageUrl: cellData.imageUrl,
                                               id: cellData.id,
                                               types:cellData.types.map{PokemonType(slot: 0, type: BasicType(name: $0, url: ""))},
                                               temp: PokemonEvoTemp(species: cellData.species, order: cellData.evoOrder ?? 0, evolutionDetails: [EvolutionDetails(gender: cellData.gender, min_level: cellData.minLevel, trigger: nil)]),
                                               color: cellData.color,
                                               formDescriptions: cellData.formDescription,
                                               isSaved: cellData.isSaved,
                                               evoChain: cellData.evoChain),
                                true))
                        
                    }catch {
                        print(error)
                        return Result.failure(error as! ParseResponseError)
                    }
                }
            }
        }
        return networkService
            .fetchSpecies(url: speciesUrl)
            .map { response -> PokemonSpeciesResponse in
                do {
                    let species = try response.get()
                    return species
                } catch let error {
                    throw error
                }
            }
            .flatMap{[unowned self] species in
                return self.networkService.fetchEvolution(url: species.evolutionChain["url"]!).map{(evo: $0,species: species)}
            }
            .map{ [unowned self] response -> (evoChain: [PokemonEvoTemp], species: PokemonSpeciesResponse) in
                do {
                    let evoData = try response.evo.get()
                    let chains = self.handleEvoChain(evoData.chain, order: 0)
                    let species = response.species
                    return (evoChain: chains,species: species)
                } catch {
                    throw error
                }
            }
            .flatMap { [unowned self] data in
                // Ex: 1,2,3
                let evoIdChain = data.evoChain.reduce(""){
                    let newString = String($1.species.url.split(separator: "/").last ?? "")
                    if $0 == "" {
                        return newString
                    }
                    return $0+","+newString
                }
                return Single.zip(
                    data.evoChain.map{ evoTemp in
                        let id = String(evoTemp.species.url.split(separator: "/").last ?? "")
                        return Single.zip(
                            self.networkService.fetchPokemonDetailByKey(key: id),
                            Single.just(evoTemp),
                            Single.just("\(data.species.id)" == id ? data.species : nil))
                            .map{ _data -> Result<(evoData: PokemonEvoData, isLocalData: Bool),ParseResponseError> in
                                let detail = try! _data.0.get()
                                let evoTemp = _data.1
                                let species = _data.2

                                return .success((PokemonEvoData(name: detail.name, imageUrl: detail.sprites.frontDefault, id: detail.id, types: detail.types, temp: evoTemp, color: species?.color.name, formDescriptions: species?.formDescriptions,isSaved: detail.isSave ?? false, evoChain: evoIdChain),false))
                            }
                    })
            }
            .subscribe(on: userInteractQueue)
    }
    
    func localFetchPokemonCellData(id: Int) -> PokemonCellData? {
        return localService.fetchLocalPokemonBy(id: id)
    }
    
    func handleEvoChain(_ chain: ChainData, order: Int) -> [PokemonEvoTemp] {
        var result = [PokemonEvoTemp(species: chain.species, order: order, evolutionDetails: chain.evolutionDetails)]
        if chain.evolvesTo.count > 0 {
            result.append(contentsOf: chain.evolvesTo.flatMap{handleEvoChain($0,order: order+1)})
            return result
        } else {
            return result
        }
    }
}
