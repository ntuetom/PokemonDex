//
//  PokemonCellData.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxDataSources

struct PokemonCellData: Decodable, IdentifiableType, Hashable {

    let name: String
    var id: Int
    var url: String
    var types: [String]
    
    typealias Identity = Int
    
    var identity: Identity {
        return id
    }
    
    init(name: String = "", id: Int = 0, url: String, types: [String]) {
        self.name = name
        self.id = id
        self.url = url
        self.types = types
    }
    
    static func == (lhs: PokemonCellData, rhs: PokemonCellData) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.url == rhs.url &&
            lhs.types == rhs.types
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(url)
        hasher.combine(types)
    }
}
typealias PokemonSectionDataType = AnimatableSectionModel<String,PokemonCellData>
