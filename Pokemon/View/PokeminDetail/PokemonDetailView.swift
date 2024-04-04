//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/31.
//

import UIKit

class PokemonDetailView: BaseView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = commonBGColor
        return iv
    }()
    
    lazy var idLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    lazy var selectedImage: UIImage = {
        return UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)
    }()
    
    lazy var unSelectedImage: UIImage = {
        return UIImage(systemName: "star")!.withRenderingMode(.alwaysTemplate)
    }()
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(unSelectedImage, for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    lazy var evoChart: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(PokemonListCell.self, forCellWithReuseIdentifier: "PokemonListCell")
        cv.register(EvoSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EvoSectionHeader")
        cv.backgroundColor = commonBGColor
        return cv
    }()
    
    lazy var evoLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = commonBGColor
        lb.textColor = .red
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.textAlignment = .center
        lb.text = "Evolution Chain"
        return lb
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kOffset
        layout.minimumInteritemSpacing = kOffset
        return layout
    }()
    
    lazy var desctiptionLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var typeLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    override func initSetupSubviews() {
        super.initSetupSubviews()
        addSubview(saveBtn)
        addSubview(evoLabel)
        addSubview(imageView)
        addSubview(idLabel)
        addSubview(desctiptionLabel)
        addSubview(typeLabel)
        addSubview(evoChart)
    }
    
    override func makeSubviewConstraints() {
        super.makeSubviewConstraints()
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(kOffset)
        }
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(idLabel)
            make.trailing.equalToSuperview().offset(-kOffset)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalTo(imageView.snp.height)
            make.centerX.equalToSuperview()
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(kOffset)
            make.centerX.equalToSuperview()
        }
        desctiptionLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(kOffset)
            make.trailing.equalToSuperview().offset(-kOffset)
            make.leading.equalToSuperview().offset(kOffset)
        }
        evoLabel.snp.makeConstraints { make in
            make.top.equalTo(desctiptionLabel.snp.bottom).offset(kOffset)
            make.leading.equalToSuperview().offset(kOffset)
            make.trailing.equalToSuperview().offset(-kOffset)
        }
        evoChart.snp.makeConstraints { make in
            make.top.equalTo(evoLabel.snp.bottom)
            make.leading.equalToSuperview().offset(kOffset)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setupReferencingOutlets(owner: AnyObject?) {
        if let vc = owner as? PokemonDetailViewController {
            vc.collectionView = evoChart
            vc.saveButton = saveBtn
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = frame.height*0.3/2
    }
    
    func setup(basicData: PokemonCellData) {
        if let url = URL(string: basicData.imageUrl) {
            imageView.kf.setImage(with: url)
        }
        idLabel.text = "#\(String(format: "%04d", basicData.id))"
        typeLabel.text = basicData.types.reduce(""){
            if $0 != "" {
                return "\($0 ?? ""),\($1)"
            }
            return $1
        }
        saveBtn.setImage(basicData.isSaved ? selectedImage : unSelectedImage, for: .normal)
    }
    
    func toggleSaveButton(_ toggle: Bool) {
        saveBtn.setImage(toggle ? selectedImage : unSelectedImage, for: .normal)
    }
    
    func setup(species: PokemonSpeciesResponse) {
        if species.formDescriptions.count > 0 ,let desc = species.formDescriptions.filter({$0.language.name == "en"}).first {
            desctiptionLabel.text = desc.description
        } else {
            desctiptionLabel.isHidden = true
        }
        backgroundColor = UIColor().named(species.color.name)
    }
}
