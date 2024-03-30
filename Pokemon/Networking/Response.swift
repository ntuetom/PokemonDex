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

struct BasicType: Decodable {
    let name: String
    let url: String
}
