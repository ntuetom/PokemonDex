//
//  PokemonCellData.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxDataSources

struct PokemonCellData: Decodable, IdentifiableType, Hashable {

    let name: String
    let id: Int
    let url: String
    let types: [String]
    let species: BasicType
    
    typealias Identity = Int
    
    var identity: Identity {
        return id
    }
    
    init(name: String = "", id: Int = 0, url: String, types: [String], species: BasicType) {
        self.name = name
        self.id = id
        self.url = url
        self.types = types
        self.species = species
    }
    
    static func == (lhs: PokemonCellData, rhs: PokemonCellData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(url)
        hasher.combine(types)
        hasher.combine(species)
    }
}
typealias PokemonSectionDataType = AnimatableSectionModel<String,PokemonCellData>
