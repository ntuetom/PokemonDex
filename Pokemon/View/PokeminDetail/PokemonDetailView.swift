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
        return iv
    }()
    
    override func initSetupSubviews() {
        super.initSetupSubviews()
        addSubview(imageView)
    }
    
    override func makeSubviewConstraints() {
        super.makeSubviewConstraints()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(kOffset)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
    }
    
    func setup(url: String) {
        if let url = URL(string: url) {
            imageView.kf.setImage(with: url)
        }
    }
}
