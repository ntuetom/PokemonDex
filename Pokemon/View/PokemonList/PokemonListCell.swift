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
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var idLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var likeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .yellow
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.imageView?.layer.borderColor = UIColor.black.cgColor
        button.imageView?.layer.borderWidth = 2
        return button
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
    
    func setup(data: PokemonEvoData) {
        nameLabel.text = data.name
        idLabel.text = "#\(String(format: "%04d", data.id))"
        typesLabel.text = data.types.map{$0.type.name}.reduce(""){$0+"\n"+$1}
        likeBtn.isHidden = true
        if let url = URL(string: data.imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setup(data: PokemonCellData) {
        nameLabel.text = data.name
        idLabel.text = "#\(String(format: "%04d", data.id))"
        typesLabel.text = data.types.reduce(""){$0+"\n"+$1}
        if let url = URL(string: data.imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setupView() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        contentView.addSubview(likeBtn)
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
        likeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kOffset)
            make.trailing.equalToSuperview().offset(-kOffset)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kOffset)
            make.leading.equalToSuperview().offset(kOffset)
        }
        imageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(kOffset)
//            make.bottom.equalToSuperview().offset(-kOffset)
            make.edges.equalToSuperview().offset(kOffset)
        }
        typesLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-kOffset)
            make.bottom.equalToSuperview().offset(-kOffset)
        }
    }
}
