//
//  API.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//
import Moya

enum PokeAPI {
    case fetchPokemonList(offset: Int, limit: Int)
    case fetchPokemonDetail(url: String)
    case fetchEvolutionChain(url: String)
    case fetchPokemonSpecies(url: String)
}

extension PokeAPI: TargetType {
    public var baseURL: URL {
        let path = pokemonDomain.domain
        switch self {
        case .fetchPokemonList:
            return URL(string: path)!
        case .fetchPokemonDetail(let url):
            return URL(string: url)!
        case .fetchEvolutionChain(let url):
            return URL(string: url)!
        case .fetchPokemonSpecies(let url):
            return URL(string: url)!
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
        switch self {
        case .fetchPokemonList(let offset, let limit):
            return .requestParameters(parameters: ["offset" : offset, "limit": limit], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
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

