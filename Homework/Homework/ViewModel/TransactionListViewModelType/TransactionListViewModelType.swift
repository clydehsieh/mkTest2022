//
//  TransactionListViewModelType.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit
import RxRelay

protocol TransactionListViewModelType {
    // input
    func fetchList()
    
    //output
    var reloadListevent: PublishRelay<[NoteItem]> { get }
    var errorEvent: PublishRelay<Error> { get }
}
