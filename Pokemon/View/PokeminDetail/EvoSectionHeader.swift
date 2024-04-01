//
//  EvoSectionHeader.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/1.
//

import UIKit
import SnapKit

class EvoSectionHeader: UICollectionReusableView {
    lazy var label: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.black
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(kOffset)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String) {
        label.text = text
    }
}
