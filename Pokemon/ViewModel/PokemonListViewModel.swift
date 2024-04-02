//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxCocoa
import RxSwift

class PokemonListViewModel: BaseViewModel, PokemonAttributeProtocol {
    
    let pokemonDetailDataSource = BehaviorRelay<[PokemonCellData]>(value: [])
    let isSaved = BehaviorRelay<Bool>(value: false)
    let didClickCellEvent = PublishSubject<PokemonCellData>()
    let reloadCellsEvent = PublishSubject<(cell: UICollectionViewCell, at: IndexPath)>()
    let saveBtnEvent = PublishSubject<PokemonCellData>()
    let cellSize: CGSize
     
    private var totalCount = 0
    private var limit = 20
    private var offset = 0
    private var pokemonDetailTempDataSource: [PokemonCellData] = []
    
    var hasRefreshEnd: Bool {
        guard totalCount > pokemonDetailDataSource.value.count else {
            print("All Pokemon Reload Complete")
            return true
        }
        return false
    }
    
    override init() {
        let w = (kScreenW-3*kOffset)/2
        cellSize = CGSize(width: w, height: w)
        super.init()
        subscribe()
    }
    
    func subscribe() {
        reloadCellsEvent.subscribe(onNext: { [weak self] _,indexPath in
            guard let self = self else {return}
            let rowIndex = indexPath.row+1
            if rowIndex % self.limit == 0 && rowIndex == self.pokemonDetailDataSource.value.count {
                print("reloadCells:",rowIndex)
                if !self.hasRefreshEnd {
                    self.getList()
                }
            }
        }).disposed(by: disposeBag)
        saveBtnEvent.bind{ [unowned self] cellData in
            var tempArray = self.pokemonDetailDataSource.value
            if let existIndex = tempArray.firstIndex(where: {$0.id == cellData.id}) {
                tempArray[existIndex].isSaved = !tempArray[existIndex].isSaved
            }
            let tempIndex = cellData.id - 1
            if tempIndex < self.pokemonDetailTempDataSource.count {
                self.pokemonDetailTempDataSource[tempIndex].isSaved = !self.pokemonDetailTempDataSource[tempIndex].isSaved
            }
            self.pokemonDetailDataSource.accept(tempArray.filter({$0.isSaved || !self.isSaved.value}))
        }.disposed(by: disposeBag)
        isSaved.bind { [unowned self] toggle in
            if toggle {
                self.pokemonDetailTempDataSource = self.pokemonDetailDataSource.value
                self.pokemonDetailDataSource.accept(self.pokemonDetailDataSource.value.filter{$0.isSaved})
            } else {
                self.pokemonDetailDataSource.accept(self.pokemonDetailTempDataSource)
            }
        }.disposed(by: disposeBag)
    }
    
    func getList() {
        let pokemonList = PublishSubject<[BasicType]>()
        fetchPokemonList(offset: offset, limit: limit)
            .subscribe(onSuccess: {[weak self]response in
                switch response {
                case .success(let data):
                    self?.totalCount = data.count
                    pokemonList.onNext(data.results)
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
        
        pokemonList
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMap{Observable.from($0)}.map{$0.url}.flatMap{[weak self] url -> Observable<Result<PokemonDetailResponse,ParseResponseError>> in
                guard let self = self else {return Observable.empty()}
                return self.fetchPokemonDetail(url: url).asObservable()}
            .subscribe(onNext: { [weak self] response in
                guard let self = self else {return}
                switch response {
                case .success(let detail):
                    let pokemonCellData = PokemonCellData(name: detail.name, id: detail.id, imageUrl: detail.sprites.frontDefault, types: detail.types.map{$0.type.name}, species: detail.species)
                    var tempArray = self.pokemonDetailDataSource.value
                    tempArray.append(pokemonCellData)
                    tempArray.sort{$0.id < $1.id}
                    self.pokemonDetailDataSource.accept(tempArray)
//                    self?.pokemonDetailDataSource.acceptAppending(pokemonCellData)
//                    print("success", detail)
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
        offset += limit
    }
}
