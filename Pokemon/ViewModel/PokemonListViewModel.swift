//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxCocoa
import RxSwift

class PokemonListViewModel: BaseViewModel {
    
    let pokemonDetailDisplayDataSource = BehaviorRelay<[PokemonCellData]>(value: [])
    let isSaved = BehaviorRelay<Bool>(value: false)
    let didClickCellEvent = PublishSubject<PokemonCellData>()
    let reloadCellsEvent = PublishSubject<(cell: UICollectionViewCell, at: IndexPath)>()
    let saveBtnEvent = PublishSubject<PokemonCellData>()
    let cellSize: CGSize
    
    private var totalCount = 0
    private var limit = 20
    private var offset = 0
    private var pokemonDetailDataSource: [PokemonCellData] = []
    private let service: PokemonService
    
    var hasRefreshEnd: Bool {
        guard totalCount > pokemonDetailDataSource.count else {
            print("All Pokemon Reload Complete \(pokemonDetailDataSource.count)")
            return true
        }
        return false
    }
    
    init(service: PokemonService = IntegrationDataService()) {
        let w = (kScreenW-3*kOffset)/2
        cellSize = CGSize(width: w, height: w)
        self.service = service
        super.init()
        subscribe()
    }
    
    func subscribe() {
        reloadCellsEvent.subscribe(onNext: { [weak self] _,indexPath in
            guard let self = self else {return}
            let rowIndex = indexPath.row+1
            if rowIndex % self.limit == 0 && rowIndex == self.pokemonDetailDisplayDataSource.value.count {
//                print("reloadCells:",rowIndex)
                if !self.hasRefreshEnd {
                    self.getList()
                }
            }
        }).disposed(by: disposeBag)
        
        saveBtnEvent.bind{ [unowned self] cellData in
            var tempArray = self.pokemonDetailDisplayDataSource.value
            if let existIndex = tempArray.firstIndex(where: {$0.id == cellData.id}) {
                tempArray[existIndex].isSaved = !tempArray[existIndex].isSaved
            }

            if cellData.id < self.pokemonDetailDataSource.count + 1{
                self.updateDetailDataStore(id: cellData.id)
            }
            self.pokemonDetailDisplayDataSource.accept(tempArray.filter({$0.isSaved || !self.isSaved.value}))
        }.disposed(by: disposeBag)
        
        isSaved.bind { [unowned self] toggle in
            if toggle {
                self.pokemonDetailDisplayDataSource.accept(self.pokemonDetailDisplayDataSource.value.filter{$0.isSaved})
            } else {
                self.pokemonDetailDisplayDataSource.accept(self.pokemonDetailDataSource)
            }
        }.disposed(by: disposeBag)
    }
    
    func updateDetailDataStore(id: Int) {
        pokemonDetailDataSource[id-1].isSaved = !pokemonDetailDataSource[id-1].isSaved
        DatabaseService.instance.update(qId: id, model: pokemonDetailDataSource[id-1])
    }
    
    func insertDetailDataSource(data: PokemonCellData) -> Array<PokemonCellData> {
        DatabaseService.instance.insert(models: [data])
        pokemonDetailDataSource.append(data)
        pokemonDetailDataSource.sort{$0.id < $1.id}
        return pokemonDetailDataSource
    }
    
    
    func getList() {
        offset = pokemonDetailDataSource.count
        service
            .fetchPokemonDetailCombine(offset: offset, limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] response in
                guard let self = self, let data = response.element else {return}
                self.totalCount = data.count
                switch data.detail {
                case .success(let detail):
                    let pokemonCellData = PokemonCellData(name: detail.name, id: detail.id, imageUrl: detail.sprites.frontDefault, types: detail.types.map{$0.type.name}, species: detail.species, isSaved: detail.isSave ?? false)
                    let tempArray = self.insertDetailDataSource(data: pokemonCellData)
                    self.pokemonDetailDisplayDataSource.accept(tempArray)
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
    }
}
