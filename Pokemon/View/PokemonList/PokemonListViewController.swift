//
//  ViewController.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit
import RxSwift
import RxDataSources

class PokemonListViewController: BaseViewController {
    
    private var viewModel: PokemonListViewModel!
    private var contentView: PokemonListView!
    weak var collectionView: UICollectionView!
    
    lazy var dataSource = {
        return RxCollectionViewSectionedAnimatedDataSource<PokemonSectionDataType>(
            configureCell: { [weak self] (dataSource, cv, indexPath, item) in
              if let cell = cv.dequeueReusableCell(withReuseIdentifier: "PokemonListCell", for: indexPath) as? PokemonListCell {
                  cell.setup(data: item)
                  cell.saveBtn.rx.tap.bind{ [weak self] in
                      self?.viewModel.saveBtnEvent.onNext(item)
                  }.disposed(by: cell.disposeBag)
                  return cell
              }
              return UICollectionViewCell()
          })
    }()
    
    lazy var savedListIcon: UIImage = {
        return UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)
    }()
    
    lazy var allListIcon: UIImage = {
        return UIImage(systemName: "star")!.withRenderingMode(.alwaysTemplate)
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: allListIcon)
        barButton.tintColor = UIColor.systemYellow
        return barButton
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        binding()
        initializeData()
    }
    
    func setupLayout() {
        title = "PokemonDex"
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func binding() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.pokemonDetailDataSource.asDriver()
            .distinctUntilChanged()
            .map { [PokemonSectionDataType(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        collectionView.rx.modelSelected(PokemonCellData.self).bind(to: viewModel.didClickCellEvent).disposed(by: disposeBag)
        collectionView.rx.willDisplayCell.bind(to: viewModel.reloadCellsEvent).disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap.bind { [weak self] in
            guard let self = self else {return}
            let newValue = !self.viewModel.isSaved.value
            self.viewModel.isSaved.accept(newValue)
            let image = newValue ? self.savedListIcon : self.allListIcon
            self.navigationItem.rightBarButtonItem?.image = image
        }.disposed(by: disposeBag)
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
