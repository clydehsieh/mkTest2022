//
//  NoteItem.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

struct NoteItem: Decodable {
    var time: Date
    var title: String
    var description: String
    var details: [NoteItemDetail]?
    
}

extension NoteItem {
    var displayDescription: String {
        "\(time.yymmdd) \(title) \(description)"
    }
    
    static func mock() -> NoteItem {
        
        let count = (1...5).randomElement()!
        
        var infos:  [NoteItemDetail] = []
        while infos.count < count {
            infos.append(NoteItemDetail.mock())
        }
        
        return NoteItem.init(time: Date(),
                             title: self.titleArray().randomElement()!,
                             description: self.desArray().randomElement()!,
                             details: infos )
    }
    
    static func titleArray() -> [String] {
        ["TitleA", "TitleB", "TitleC", "TitleD"]
    }
    
    static func desArray() -> [String] {
        ["descriptionA", "descriptionB", "descriptionC", "descriptionD"]
    }
}
