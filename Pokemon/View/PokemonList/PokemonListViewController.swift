//
//  ViewController.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit
import RxSwift
import RxDataSources

class PokemonListViewController: UIViewController {
    
    private var viewModel: PokemonListViewModel!
    private var contentView: PokemonListView!
    private var disposebag = DisposeBag()
    weak var collectionView: UICollectionView!
    
    lazy var dataSource = {
        return RxCollectionViewSectionedAnimatedDataSource<PokemonSectionDataType>(
            configureCell: { (dataSource, cv, indexPath, item) in
              if let cell = cv.dequeueReusableCell(withReuseIdentifier: "PokemonListCell", for: indexPath) as? PokemonListCell {
                  cell.setup(data: item)
                  return cell
              }
              return UICollectionViewCell()
          })
    }()
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.contentView = PokemonListView(owner: self)
        title = "PokemonDex"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        initializeData()
    }
    
    func binding() {
        collectionView.rx.setDelegate(self).disposed(by: disposebag)
        viewModel.pokemonDetailDataSource.asDriver()
            .distinctUntilChanged()
            .map { [PokemonSectionDataType(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposebag)
        collectionView.rx.modelSelected(PokemonCellData.self).bind(to: viewModel.didClickCell).disposed(by: disposebag)
        collectionView.rx.willDisplayCell.bind(to: viewModel.reloadCells).disposed(by: disposebag)
    }

    func initializeData() {
        viewModel.getList()
    }
}

extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }
}
