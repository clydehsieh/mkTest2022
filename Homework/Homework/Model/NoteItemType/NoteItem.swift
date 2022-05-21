//
//  NoteItem.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

struct NoteItem: Codable {
    var id: Int
    var time: Date
    var title: String
    var description: String
    var details: [NoteItemDetail]?
}

//MARK: - view display
extension NoteItem {
    var displayDescription: String {
        "\(time.yymmdd) \(title) \(description)"
    }
}

//MARK: - mock data
extension NoteItem {
    static func mock() -> NoteItem {
        
        let count = (1...5).randomElement()!
        
        var infos:  [NoteItemDetail] = []
        while infos.count < count {
            infos.append(NoteItemDetail.mock())
        }
        
        return NoteItem.init(id: (1...65530).randomElement()!,
                             time: Date(),
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
