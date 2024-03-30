//
//  API.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//
import Moya

enum PokeAPI {
    case fetchPokemonList
    case fetchPokemonDetail(url: String)
    case fetchEvolutionChain(id: Int)
    case fetchPokemonSpecies(id: Int)
}

extension PokeAPI: TargetType {
    public var baseURL: URL {
        let path = pokemonDomain.domain
        switch self {
        case .fetchPokemonList:
            return URL(string: path)!
        case .fetchPokemonDetail(let url):
            return URL(string: url)!
        case .fetchEvolutionChain(let id):
            return URL(string: path)!
        case .fetchPokemonSpecies(let id):
            return URL(string: path)!
        }
        
    }
    
    public var path: String {
        switch self {
        case .fetchPokemonList:
            return Domain.Path.list.pathValue
        default:
            return ""
        }
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var method: Method {
        return .get
    }
    
    public var headers: [String : String]? {
        let header = ["Content-Type": "application/json"]
        return header
    }
    
    public var sampleData: Data {
        return Data()
    }
}

