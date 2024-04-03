//
//  Database.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/2.
//

import SQLite

class DataBase {    
    private var dbPath: String
    private var tableNames: Array<String> = []
    private let db: Connection
    private var table: Table?
    
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let imageUrl = Expression<String>("imageUrl")
    let isSaved = Expression<Bool>("isSaved")
    let types = Expression<String>("types")
    let speciesUrl = Expression<String>("speciesUrl")
    
    init() throws {
        self.dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.db = try Connection("\(self.dbPath)/db.sqlite3")
    }
    
    func createTable(tableName: String) throws {
        do {
            table = Table(tableName)
            try db.run(table!.create(ifNotExists: true) { t in
                t.column(name, unique: true)
                t.column(id, primaryKey: true)
                t.column(imageUrl, unique: true)
                t.column(isSaved)
                t.column(types)
                t.column(speciesUrl)
            })
        } catch let error {
            throw error
        }
        
    }

    func insert(models: [PokemomCellDao]) throws {
        do {
            guard let _table = table else{return}
            let lastRowid = try db.run(_table.insertMany(models))
            print("last inserted id: \(lastRowid)")
        } catch let error {
            throw error
        }
    }

    func query() throws -> Array<PokemomCellDao>? {
        if let table = table {
            do {
                let mapRowIterator = try db.prepareRowIterator(table)
                let models = try mapRowIterator.map { row -> PokemomCellDao in
                    return try row.decode()
                }
                return models
            } catch {
                throw error
            }
        }
        return nil
    }

    @discardableResult
    func update(qId: Int64, model: PokemomCellDao) throws -> Bool {
        if let updateTable = table?.filter(id == qId) {
            do {
                let code = try db.run(updateTable.update(isSaved <- model.isSaved))
                print(code)
                if code > 0 {
                    return true
                }
            } catch {
                print(error)
            }
        }
        return false
    }
}
