//
//  PokemonEvoData.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/1.
//

import RxDataSources

struct PokemonEvoTemp {
    let species: BasicType
    let order: Int
    let evolutionDetails: [EvolutionDetails]
}

struct PokemonEvoData: Decodable, IdentifiableType, Hashable {
    let name: String
    let id: Int
    let types: [PokemonType]
    let imageUrl: String
    let gender: Int?
    let minLevel: Int?
    let species: BasicType
    let order: Int
    let color: String?
    let formDescriptions: [FormDescription]?
    let isSaved: Bool
    let evoChain: String?
    
    typealias Identity = Int
    
    var identity: Identity {
        return id
    }
    
    init(name: String = "", imageUrl: String, id: Int = 0, types: [PokemonType], temp: PokemonEvoTemp, color: String? = nil, formDescriptions: [FormDescription]? = nil, isSaved: Bool = false,
        evoChain: String? = nil) {
        
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
        self.types = types
        self.species = temp.species
        self.order = temp.order
        if let temp = temp.evolutionDetails.first {
            self.gender = temp.gender
            self.minLevel = temp.min_level
        } else {
            self.gender = nil
            self.minLevel = nil
        }
        self.color = color
        self.formDescriptions = formDescriptions
        self.isSaved = isSaved
        self.evoChain = evoChain
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(types)
        hasher.combine(species)
        hasher.combine(gender)
        hasher.combine(minLevel)
        hasher.combine(color)
        hasher.combine(formDescriptions)
    }
}
typealias PokemonEvoSectionDataType = AnimatableSectionModel<String,PokemonEvoData>
