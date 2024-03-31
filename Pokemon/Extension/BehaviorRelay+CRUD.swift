//
//  BehaviorRelay+CRUD.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/30.
//

import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func upsert(_ element: Element.Element) {
        var oldValue = value
        if true {
            
        } else {
            acceptAppending(element)
        }
    }
    
    func sorted() {
        
    }
    
    func acceptAppending(_ element: Element.Element) {
        accept(value + [element])
    }
    
    func remove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
}
