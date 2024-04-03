//
//  PokemomCellDao.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/3.
//

import Foundation

struct PokemomCellDao: Codable {
    let name: String
    let id: Int
    let imageUrl: String
    let types: String
    let speciesUrl: String
    var isSaved: Bool
    
    func toPokemoCellData() -> PokemonCellData {
        let daoTypes = types.split(separator: ",").map{String($0)}
        return PokemonCellData(name: name, id: id, imageUrl: imageUrl, types: daoTypes, species: BasicType(name: name, url: speciesUrl), isSaved: isSaved)
    }
}
