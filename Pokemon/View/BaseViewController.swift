//
//  BaseViewController.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/1.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    deinit {
        disposeBag = DisposeBag()
    }
}
