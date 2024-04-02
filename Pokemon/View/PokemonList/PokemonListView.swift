//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit

class PokemonListView: BaseView {
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = commonBGColor
        cv.register(PokemonListCell.self, forCellWithReuseIdentifier: "PokemonListCell")
        return cv
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kOffset
        layout.minimumInteritemSpacing = kOffset
        return layout
    }()
    
    override init(owner: AnyObject, frame: CGRect? = nil) {
        super.init(owner: owner, frame: frame)
        backgroundColor = .brown
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initSetupSubviews() {
        super.initSetupSubviews()
        addSubview(collectionView)
    }
    
    override func makeSubviewConstraints() {
        super.makeSubviewConstraints()
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(kOffset).priority(750)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setupOutlets(owner: AnyObject?) {
        super.setupOutlets(owner: owner)
        if let vc = owner as? PokemonListViewController {
            vc.collectionView = collectionView
        }
    }
}
