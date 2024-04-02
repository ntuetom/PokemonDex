//
//  BaseView.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import UIKit

class BaseView: UIView {
    
    unowned var owner: AnyObject
    
    init(owner: AnyObject, frame: CGRect? = nil) {
        self.owner = owner
        super.init(frame: .zero)
        backgroundColor = .white
        initSetupSubviews()
        makeSubviewConstraints()
        setupOutlets(owner: owner)
        setupReferencingOutlets(owner: owner)
        setupReceivedActions(owner: owner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSetupSubviews() -> Void{
        
    }
    
    func makeSubviewConstraints() -> Void{
    }
    
    func setupOutlets(owner: AnyObject?){
        if owner != nil && owner!.isKind(of: UIViewController.classForCoder()){
            (owner as! UIViewController).view = self
        }
    }
    
    func setupReferencingOutlets(owner: AnyObject?){
        
    }
    
    func setupReceivedActions(owner: AnyObject?){
        
    }
    
}
