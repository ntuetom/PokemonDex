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
    let cellSize: CGSize
    let didClickCell = PublishSubject<PokemonCellData>()
    let reloadCells = PublishSubject<(cell: UICollectionViewCell, at: IndexPath)>()
    private var totalCount = 0
    private var limit = 20
    private var offset = 0
    
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
        reloadCells.subscribe(onNext: { [weak self] _,indexPath in
            guard let self = self else {return}
            let rowIndex = indexPath.row+1
            if rowIndex + self.limit/2 == self.pokemonDetailDataSource.value.count {
                print("reloadCells:",rowIndex)
                if !self.hasRefreshEnd {
                    self.getList()
                }
            }
        }).disposed(by: disposeBag)
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
