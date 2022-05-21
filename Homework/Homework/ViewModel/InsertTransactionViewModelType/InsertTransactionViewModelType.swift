//
//  InsertTransactionViewModelType.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit
import RxRelay

protocol InsertTransactionViewModelType {
    // source
    var time: BehaviorRelay<Date> { get }
    var title: BehaviorRelay<String> { get }
    var description: BehaviorRelay<String> { get }
    var details: BehaviorRelay<[NoteItemDetailTableViewCellViewModel]> { get }
    
    // input
    func insertNewDetail()
    func uploadCreation()
    
    // output
    var finishedUploadEvent: PublishRelay<[NoteItem]> { get }
    var finishedInsertToLocalDbEvent: PublishRelay<Void> { get }
}
