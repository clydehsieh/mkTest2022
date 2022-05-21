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
    var finishedInsertToLocalDbEvent = PublishRelay<Void>()
    
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
            }, onError: { [weak self] error in
                self?.saveToLocal()
            })
            .disposed(by: disposbag)
    }
    
    func saveToLocal() {
        weak var weakSelf = self
        DBManager.shared.insert(items: [createItem()])
            .subscribe(onNext: {
                weakSelf?.finishedInsertToLocalDbEvent.accept(())
                debugPrint("did sync server data with to local db")
            }, onError: { error in
                debugPrint("fail to fetch data from local db: \(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
}

//MARK: - export
extension InsertTransactionViewModel {
    func createUploadRequest() -> CreateModifyRequest {
        // rmeove empty detail
        let details = details.value.compactMap({ $0.mappingNoteItemDetailData() })
        
        return CreateModifyRequest(time: Int(time.value.timeIntervalSince1970),
                            title: title.value,
                            description: description.value,
                                   details: details.count > 0 ? details : nil)
    }
    
    func createItem() -> NoteItem {
        // rmeove empty detail
        let details = details.value.compactMap({ $0.mappingNoteItemDetailData() })
        
        return NoteItem(id: Int(Date().timeIntervalSince1970),
                        time: time.value,
                        title: title.value,
                        description: description.value,
                        details: details.count > 0 ? details : nil)
    }
}
