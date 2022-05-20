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
    func loadFromLocalDB()
    
    //output
    var reloadListevent: PublishRelay<[NoteItem]> { get }
    var errorEvent: PublishRelay<Error> { get }
    var reloadTotalCost: PublishRelay<Int> { get }
}
