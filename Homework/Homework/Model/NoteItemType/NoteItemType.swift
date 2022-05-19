//
//  NoteItemType.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import Foundation

protocol NoteItemType {
    var time: Date { get }
    var title: String { get }
    var description: String { get }
    var detailInfos: [NoteItemDetailType] { get }
}

extension NoteItemType {
    var displayDescription: String {
        "\(time.yymmdd) \(title) \(description)"
    }
}
