//
//  NoteItemDetailTableViewCellViewModel.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit
import RxSwift
import RxCocoa

struct NoteItemDetailTableViewCellViewModel {
    var name = BehaviorRelay<String>(value: "") {
        didSet {
            debugPrint("name \(name.value)")
        }
    }
    var price = BehaviorRelay<Int>(value: 0)
    var quantity = BehaviorRelay<Int>(value: 0)
}

extension NoteItemDetailTableViewCellViewModel {
    func mappingNoteItemDetailData() -> NoteItemDetail? {
        guard price.value > 0, quantity.value > 0, name.value.count > 0 else {
            return nil
        }
        
        return NoteItemDetail.init(name: name.value, price: price.value, quantity: quantity.value)
    }
}
