//
//  NoteItemDetailType.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

protocol NoteItemDetailType {
    var name: String { get }
    var price: Int { get }
    var quantity: Int { get }
}

extension NoteItemDetailType {
    var displayDescription: String {
        "- \(name) \(price) x \(quantity)"
    }
}

