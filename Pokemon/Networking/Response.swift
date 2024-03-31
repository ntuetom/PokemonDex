//
//  Response.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation

struct FetchPokemonListResponse: Decodable {
    let count: Int
    let previous: URL?
    let next: URL?
    let results: [PokemonBasic]
}

struct PokemonBasic: Decodable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [PokemonType]
    let species: BasicType
}

struct Sprites: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonType: Decodable {
    let slot: Int
    let type: BasicType
}

struct BasicType: Decodable, Hashable {
    let name: String
    let url: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}

struct PokemonSpeciesResponse: Decodable {
    let evolutionChain: [String:String]
    let formDescriptions: [FormDescription]
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
        case formDescriptions = "form_descriptions"
    }
}

struct FormDescription: Decodable {
    let description: String
    let language: BasicType
}

struct EvolutionResponse: Decodable {
    let chain: ChainData
    let id: Int
}

struct ChainData: Decodable {
    let evolutionDetails: [EvolutionDetails]
    let evolvesTo: [ChainData]
    let isBaby: Bool
    let species: BasicType
    
    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
        case isBaby = "is_baby"
        case species = "species"
    }
}

struct EvolutionDetails: Decodable {
    let gender: Int?
    let min_level: Int?
    let trigger: BasicType?
}
