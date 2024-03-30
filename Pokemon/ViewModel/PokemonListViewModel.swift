//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import RxCocoa
import RxSwift

class PokemonListViewModel: PokemonServiceProtocol {
    
    let disposebag = DisposeBag()
    let pokemonDetailDataSource = BehaviorRelay<[PokemonCellData]>(value: [])
    let cellSize: CGSize
    private let pokemonList = PublishSubject<[PokemonBasic]>()
    
    init() {
        let w = (kScreenW-3*kOffset)/2
        cellSize = CGSize(width: w, height: w)
    }
    
    func getList() {
        fetchPokemonList()
            .subscribe(onSuccess: {[weak self]response in
                switch response {
                case .success(let data):
                    self?.pokemonList.onNext(data.results)
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposebag)
        
        pokemonList
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMap{Observable.from($0)}.map{$0.url}.flatMap{[weak self] url -> Observable<Result<PokemonDetailResponse,ParseResponseError>> in
                guard let self = self else {return Observable.empty()}
                return self.fetchPokemonDetail(url: url).asObservable()}
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                switch response {
                case .success(let detail):
                    let pokemonCellData = PokemonCellData(name: detail.name, id: detail.id, url: detail.sprites.frontDefault, types: [detail.species.url])
                    self?.pokemonDetailDataSource.acceptAppending(pokemonCellData)
                    print("success", detail)
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposebag)
    }
}
