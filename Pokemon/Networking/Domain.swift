//
//  Domain.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation

let pokemonDomain = Domain.shared
struct Domain {
    static let shared = Domain()
    var domain = "https://pokeapi.co"
    
    enum Path {
        case list
        case detail(id: Int)
        case evolutionChain(id: Int)
        case pokemonSpecies(id: Int)
        
        var pathValue: String {
            switch self {
            case .list:
                return "api/v2/pokemon"
            case .detail(let id):
                return "api/v2/pokemon/\(id)"
            case .evolutionChain(let id):
                return "api/v2/evolution-chain/\(id)"
            case .pokemonSpecies(let id):
                return "api/v2/pokemon-species/\(id)"
            }
        }
    }
}
