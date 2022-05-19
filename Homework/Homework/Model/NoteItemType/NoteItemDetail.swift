//
//  NoteItemDetail.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

struct NoteItemDetail: NoteItemDetailType {
    var name: String
    var price: Int
    var quantity: Int
}

extension NoteItemDetail {
    static func mock() -> NoteItemDetailType {
        NoteItemDetail.init(name: self.nameArray().randomElement()!,
                            price: (10...100).randomElement()!,
                            quantity: (1...10).randomElement()!)
    }
    
    static func nameArray() -> [String] {
        ["衣服", "包包", "鞋子", "PS5"]
    }
}

