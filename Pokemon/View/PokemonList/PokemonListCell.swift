//
//  PokemonListCell.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

class PokemonListCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var typesLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var idLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemGray
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
    
    lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .systemGray
        lb.numberOfLines = 0
        return lb
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(data: PokemonEvoData) {
        nameLabel.text = data.name
        idLabel.text = "#\(String(format: "%04d", data.id))"
        typesLabel.text = data.types.map{$0.type.name}.reduce(""){
            if $0 != "" {
                return "\($0 ?? ""),\($1)"
            }
            return $1
        }
        saveBtn.isHidden = true
        if let url = URL(string: data.imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setup(data: PokemonCellData) {
        nameLabel.text = data.name
        idLabel.text = "#\(String(format: "%04d", data.id))"
        typesLabel.text = data.types.reduce(""){
            if $0 != "" {
                return "\($0 ?? "")\n\($1)"
            }
            return $1
        }
        if data.isSaved {
            saveBtn.setImage(selectedImage, for: .normal)
        } else {
            saveBtn.setImage(unSelectedImage, for: .normal)
        }
        if let url = URL(string: data.imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setupView() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        contentView.addSubview(saveBtn)
        contentView.addSubview(idLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typesLabel)
    }
    
    func setupConstraint() {
        idLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kOffset)
            make.leading.equalToSuperview().offset(kOffset)
        }
        saveBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kOffset)
            make.trailing.equalToSuperview().offset(-kOffset)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kOffset)
            make.leading.equalToSuperview().offset(kOffset)
        }
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(kOffset)
            make.bottom.trailing.equalToSuperview().offset(-kOffset)
        }
        typesLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-kOffset)
            make.bottom.equalToSuperview().offset(-kOffset)
        }
    }
}
