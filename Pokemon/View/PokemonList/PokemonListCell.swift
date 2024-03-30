//
//  PokemonListCell.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit
import SnapKit
import Kingfisher

class PokemonListCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var typesLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var idLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .gray
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(data: PokemonCellData) {
//        print("CollectionViewCell setup:",data)
        nameLabel.text = data.name
        idLabel.text = "#\(data.id)"
        if let url = URL(string: data.url) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setupView() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        contentView.addSubview(idLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typesLabel)
    }
    
    func setupConstraint() {
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kOffset)
            make.trailing.equalToSuperview().offset(-kOffset)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kOffset)
            make.leading.equalToSuperview().offset(kOffset)
        }
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview().offset(-kOffset)
        }
        typesLabel.snp.makeConstraints { make in
            make.trailing.equalTo(idLabel)
            make.bottom.equalToSuperview().offset(-kOffset)
        }
    }
}
