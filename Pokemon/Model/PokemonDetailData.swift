//
//  PokemonDetailData.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Foundation

struct PokemonDetailData: Decodable {
    let basicData: PokemonCellData
    let evoChain: ChainData
    let descriptionData: [FormDescription]
    let color: BasicType
}
