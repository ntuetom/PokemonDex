//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import MJRefresh
import UIKit

class PokemonListView: BaseView {
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.register(PokemonListCell.self, forCellWithReuseIdentifier: "PokemonListCell")
        cv.mj_footer = refreshFooter
        return cv
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kOffset
        layout.minimumInteritemSpacing = kOffset
        return layout
    }()
    
    lazy var refreshFooter: MJRefreshAutoNormalFooter = {
        let footer = MJRefreshAutoNormalFooter()
        footer.setTitle("", for: .idle)
        footer.setTitle("全部作品加載完畢", for: .noMoreData)
        return footer
    }()
    
    override func initSetupSubviews() {
        super.initSetupSubviews()
        addSubview(collectionView)
    }
    
    override func makeSubviewConstraints() {
        super.makeSubviewConstraints()
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(kOffset).priority(750)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setupOutlets(owner: AnyObject?) {
        super.setupOutlets(owner: owner)
        if let vc = owner as? PokemonListViewController {
            vc.collectionView = collectionView
            vc.refreshFooter = refreshFooter
        }
    }
    
    override func setupReceivedActions(owner: AnyObject?) {
        super.setupReceivedActions(owner: owner)
        if let vc = owner as? PokemonListViewController {
//            refreshFooter.setRefreshingTarget(vc, refreshingAction: #selector(CollectionViewController.onRefresh))
        }
    }
}
