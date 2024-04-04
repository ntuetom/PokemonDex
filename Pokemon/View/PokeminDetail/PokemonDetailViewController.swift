//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import UIKit
import RxSwift
import RxDataSources

class PokemonDetailViewController: BaseViewController {
    
    private var contentView: PokemonDetailView!
    private weak var viewModel: PokemonDetailViewModel!
    weak var collectionView: UICollectionView!
    weak var saveButton: UIButton!
    
    lazy var dataSource = {
        return RxCollectionViewSectionedAnimatedDataSource<PokemonEvoSectionDataType>(
            configureCell: { (dataSource, cv, indexPath, item) in
              if let cell = cv.dequeueReusableCell(withReuseIdentifier: "PokemonListCell", for: indexPath) as? PokemonListCell {
                  cell.setup(data: item)
                  return cell
              }
                return UICollectionViewCell()
            },configureSupplementaryView: {(dataSource, cv, kind, indexPath) in
                if let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EvoSectionHeader", for: indexPath) as? EvoSectionHeader {
                    if let item = dataSource[indexPath.section].items.first {
                        let minLevel = item.minLevel == nil ? "unknown" : "\(item.minLevel!)"
                        if indexPath.section > 0 {
                            header.setup(text: "Min Level: Lv.\(minLevel) ")
                        } else {
                            header.setup(text: "")
                        }
                    }
                    return header
                }
                return UICollectionReusableView()
            })
    }()
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PokemonDetailViewController deinit")
    }
    
    override func loadView() {
        super.loadView()
        self.contentView = PokemonDetailView(owner: self)
        title = viewModel.pokemonBasicData.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        initializeData()
        contentView.setup(basicData: viewModel.pokemonBasicData)
    }
    
    func initializeData() {
        viewModel.getSpecies()
    }
    
    func binding() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        navigationController?.delegate = self
        
        viewModel.speciesInfoEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] species in
                self.contentView.setup(species: species)
            }).disposed(by: disposeBag)
        
        viewModel.evoChainDataSource.asDriver()
            .distinctUntilChanged()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(PokemonEvoData.self)
            .bind{ [weak self] evoData in
                guard let self = self else {return}
                let cellData = self.viewModel.getSpeciesToNext(evoData: evoData)
                self.viewModel.didClickCellEvent.onNext(cellData)
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind {[unowned self] in
                let toggle = !self.viewModel.isSaved
                self.viewModel.setSaveStatus(toggle)
                self.contentView.toggleSaveButton(toggle)
            }
            .disposed(by: disposeBag)
    }
}
extension PokemonDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getCellSize(section: indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? .zero : CGSize(width: contentView.frame.width, height: 30)
    }
}

extension PokemonDetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            if coordinator.isInteractive {
                coordinator.notifyWhenInteractionChanges { [weak self] (context) in
                    if !context.isCancelled {
                        self?.viewModel.didPopBack.onNext(())
                    }
                }
                
            } else if viewController !== self {
                viewModel.didPopBack.onNext(())
            }
        }
    }
}
