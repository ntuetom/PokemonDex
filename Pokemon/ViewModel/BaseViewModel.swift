//
//  BaseViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/1.
//

import RxSwift

class BaseViewModel {
    var disposeBag = DisposeBag()
    let didPopBack = PublishSubject<Void>()
    
    deinit {
        disposeBag = DisposeBag()
        print("BaseViewModel deinit")
    }
}
