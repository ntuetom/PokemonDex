//
//  DatabaseService.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/3.
//

import Foundation

protocol DataBaseProtocol {
    func initialize()
    func createTable()
    func insert(models: [PokemonCellData])
    func query() -> [PokemonCellData]?
    func queryBy(id: Int) -> PokemonCellData?
    func update(qId: Int, model: PokemonCellData)
    func update(qId: Int, model: PokemonEvoData)
}

class DatabaseService: DataBaseProtocol {
    static let instance = DatabaseService()
    private let database: DataBase
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let userInteractQueue = DispatchQueue.global(qos: .userInteractive)
    
    init() {
        do {
            database = try DataBase.init()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func initialize() {
        self.createTable()
    }
    
    func createTable() {
        do {
            try database.createTable(tableName: "Pokemons")
        } catch {
            print(error)
        }
    }
    
    func insert(models: [PokemonCellData]) {
        utilityQueue.async {[weak self] in
            do {
                guard let self = self else {
                    print("insert self nil")
                    return
                }
                try self.database.insert(models: models.map{self.cellDataToDBCellData(data: $0)})
                
            } catch {
                print(error)
            }
        }
    }
    
    func queryBy(id: Int) -> PokemonCellData? {
        userInteractQueue.sync {
            do {
                let pokemonDao = try database.queryby(qId: Int64(id))
                return pokemonDao?.toPokemoCellData()
            } catch {
                print(error)
            }
            return nil
        }
    }
    
    func query() -> [PokemonCellData]? {
        userInteractQueue.sync {
            do {
                let pokemonDao = try database.query()
                if let dao = pokemonDao {
                    return dao.map{$0.toPokemoCellData()}
                }
            } catch {
                print(error)
            }
            return nil
        }
    }
    
    func update(qId: Int, model: PokemonEvoData) {
        utilityQueue.async {[weak self] in
            do {
                guard let self = self else {
                    print("update self nil")
                    return
                }
                try self.database.upsert(model: self.evoDataToDBCellData(data: model))
            } catch let error{
                print(error)
            }
        }
    }
    
    func update(qId: Int, model: PokemonCellData) {
        utilityQueue.async {[weak self] in
            do {
                guard let self = self else {
                    print("update self nil")
                    return
                }
                try self.database.update(qId: Int64(qId), model: self.cellDataToDBCellData(data: model))
            } catch let error{
                print(error)
            }
        }
    }
    
    func cellDataToDBCellData(data: PokemonCellData) -> PokemomCellDao {
        let daoTypes = data.types.reduce("") {
            if $0 != "" {
                return "\($0),\($1)"
            }
            return $1
        }
        return PokemomCellDao(name: data.name, id: data.id, imageUrl: data.imageUrl, types: daoTypes, speciesUrl: data.species.url, isSaved: data.isSaved)
    }
    
    func evoDataToDBCellData(data: PokemonEvoData) -> PokemomCellDao {
        let daoTypes = data.types.reduce("") {
            if $0 != "" {
                return "\($0),\($1.type.name)"
            }
            return "\($1.type.name)"
        }
        
        let formDescription = data.formDescriptions?.map{$0.description}.first
        return PokemomCellDao(name: data.name, id: data.id, imageUrl: data.imageUrl, types: daoTypes, speciesUrl: data.species.url, isSaved: data.isSaved, color: data.color, evoOrder: data.order, evoChain: data.evoChain, gender: data.gender, minLevel: data.minLevel, formDescription: formDescription)
    }
}
