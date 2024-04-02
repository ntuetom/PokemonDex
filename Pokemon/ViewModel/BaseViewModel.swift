//
//  BaseViewModel.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/1.
//

import RxSwift

class BaseViewModel {
    var disposeBag = DisposeBag()
    
    deinit {
        disposeBag = DisposeBag()
    }
}
