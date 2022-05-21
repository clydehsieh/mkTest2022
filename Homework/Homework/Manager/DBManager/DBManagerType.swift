//
//  DBManagerType.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/21.
//

import UIKit
import RxSwift

protocol DBManagerType {
    func insert(items: [NoteItem]) -> Observable<Void>
    func loadItems() -> Observable<[NoteItem]>
}
