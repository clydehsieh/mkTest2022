//
//  InsertTransactionViewModel.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit
import RxRelay
import RxSwift

class InsertTransactionViewModel: InsertTransactionViewModelType {
    // source
    var time = BehaviorRelay<Date>(value: Date())
    var title = BehaviorRelay<String>(value: "")
    var description = BehaviorRelay<String>(value: "")
    var details = BehaviorRelay<[NoteItemDetailTableViewCellViewModel]>(value: [])
    
    //
    var finishedUploadEvent = PublishRelay<[NoteItem]>()
    
    //MARK: - DI
    let apiManager: APIManager
    
    //MARK: - param
    var disposbag = DisposeBag()
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
}

extension InsertTransactionViewModel {
    func insertNewDetail() {
        var current = details.value
        current.insert(NoteItemDetailTableViewCellViewModel(), at: 0)
        details.accept(current)
    }
    
    func uploadCreation() {
        apiManager.uploadNewItem(reqeust: createUploadRequest())
            .subscribe(onNext: { [weak self] respnse in
                //
                self?.finishedUploadEvent.accept(respnse.list ?? [])
            }, onError: { error in
                debugPrint("\(error)")
            })
            .disposed(by: disposbag)
    }
}

//MARK: - export
extension InsertTransactionViewModel {
    func createUploadRequest() -> CreateModifyRequest {
        
        let details = details.value.map({ $0.mappingNoteItemDetailData() })
        
        return CreateModifyRequest(time: time.value.timeIntervalSince1970,
                            title: title.value,
                            description: description.value,
                                   details: details.count > 0 ? details : nil)
    }
}
