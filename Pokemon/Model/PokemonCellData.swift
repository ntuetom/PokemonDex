//
//  PokemonCellData.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxDataSources

struct PokemonCellData: Codable, IdentifiableType, Hashable {

    let name: String
    let id: Int
    let imageUrl: String
    let types: [String]
    let species: BasicType
    var isSaved: Bool
    
    typealias Identity = Int
    
    var identity: Identity {
        return id
    }
    
    init(name: String = "", id: Int = 0, imageUrl: String, types: [String], species: BasicType, isSaved: Bool = false) {
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
        self.types = types
        self.species = species
        self.isSaved = isSaved
    }
    
    static func == (lhs: PokemonCellData, rhs: PokemonCellData) -> Bool {
        return lhs.id == rhs.id &&
        lhs.isSaved == rhs.isSaved
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageUrl)
        hasher.combine(types)
        hasher.combine(species)
        hasher.combine(isSaved)
    }
}
typealias PokemonSectionDataType = AnimatableSectionModel<String,PokemonCellData>
