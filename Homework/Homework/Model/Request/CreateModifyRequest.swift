//
//  CreateModifyRequest.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit

struct CreateModifyRequest: Codable {
    var time: TimeInterval
    var title: String
    var description: String
    var details: [NoteItemDetail]?
}
