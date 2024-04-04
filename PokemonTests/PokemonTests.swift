//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Wu hung-yi on 2024/3/29.
//

import XCTest
import RxSwift
@testable import Pokemon

class PokemonTests: XCTestCase {

    var pokemonListVM: PokemonListViewModel!
    var pokemonDetailVM: PokemonDetailViewModel!
    var cellData: PokemonCellData!
    var mockService = MockService()
    var mockDB = MockDatabase()
    var disposeBag = DisposeBag()
    var testData: (detail: Result<PokemonDetailResponse, ParseResponseError>, count: Int)!
    override func setUpWithError() throws {
        cellData = PokemonCellData(imageUrl: "", types: [], species: BasicType(name: "", url: ""))
        pokemonDetailVM = PokemonDetailViewModel(data: cellData, service: mockService, dbService: mockDB)
        pokemonListVM = PokemonListViewModel(service: mockService, dbService: mockDB)
        testData = (detail: .success(PokemonDetailResponse(id: 0, name: "", sprites: Sprites(frontDefault: ""), types: [], species: BasicType(name: "", url: ""), isSave: false)), count: 100)
        mockService.testData = testData
    }

    override func tearDownWithError() throws {
        disposeBag = DisposeBag()
    }

    func testHandleSection() throws {
        let (input,expect) = genEvoData(i: 4)
        let result = pokemonDetailVM.handleSection(input)
        XCTAssertEqual(result, expect, "Result is wrong.")
    }
    
    func testGetList() {
        pokemonListVM.getList()
        pokemonListVM.pokemonDetailDisplayDataSource.subscribe(onNext: {[weak self]result in
            do {
                let detail = try self!.testData.detail.get()
                let pokemonCellData = PokemonCellData(name: detail.name, id: detail.id, imageUrl: detail.sprites.frontDefault, types: detail.types.map{$0.type.name}, species: detail.species, isSaved: detail.isSave ?? false)
                XCTAssertEqual(result, [pokemonCellData], "Result is wrong.")
            } catch {
                XCTFail()
            }
        }).disposed(by: disposeBag)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func genEvoData(i: Int) -> (input: [PokemonEvoData], output: [PokemonEvoSectionDataType]) {
        let count = Array(0...i)
        return (
            count.map{ _i in
                PokemonEvoData(name: "my name is count", imageUrl: "", id: _i, types: [], temp: PokemonEvoTemp(species: BasicType(name: "", url: ""), order: 0, evolutionDetails: []), isSaved: false)},
            [PokemonEvoSectionDataType(model: "0", items: count.map{_i in
                PokemonEvoData(name: "my name is count", imageUrl: "", id: _i, types: [], temp: PokemonEvoTemp(species: BasicType(name: "", url: ""), order: 0, evolutionDetails: []), isSaved: false)})]
        )
        
    }

}
