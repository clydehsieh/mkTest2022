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
