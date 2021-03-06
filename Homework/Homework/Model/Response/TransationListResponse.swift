//
//  TransationListResponse.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit

struct TransationListResponse: Decodable {
    var list: [NoteItem]?
    
    init(list: [NoteItem]?) {
        self.list = list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.list = try container.decode([NoteItem].self)
    }
}
