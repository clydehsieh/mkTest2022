//
//  TransactionListViewModel.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit
import RxRelay
import RxSwift

final class TransactionListViewModel: TransactionListViewModelType {
    // input
    var fetchListEvent = PublishRelay<Void>()
    
    //output
    var reloadListevent = PublishRelay<[NoteItem]>()
    var errorEvent = PublishRelay<Error>()
    
    //MARK: - DI
    let apiManager: APIManager
    
    //MARK: - param
    var disposbag = DisposeBag()
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        
        setupBinding()
    }
    
    private func setupBinding() {
   
    }
}

extension TransactionListViewModel {
    func fetchList() {
        weak var weakSelf = self
        apiManager.getTransactions()
            .subscribe(onNext: { response in
                guard let list = response.list else {
                    return
                }
                
                debugPrint("fetch items \(list.count) from server")
                weakSelf?.reloadListevent.accept(list)
                weakSelf?.saveToLocalDB(items: list)
            }, onError: { error in
                weakSelf?.errorEvent.accept(error)
                debugPrint("\(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
    
    func saveToLocalDB(items: [NoteItem]) {
        weak var weakSelf = self
        
        DBManager.shared.insert(items: items)
            .subscribe(onNext: {
                debugPrint("save to local success")
                weakSelf?.loadFromLocalDB()
            }, onError: { error in
                weakSelf?.errorEvent.accept(error)
                weakSelf?.loadFromLocalDB()
                debugPrint("save to local fail \(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
    
    func loadFromLocalDB() {
        weak var weakSelf = self
        DBManager.shared.loadItems()
            .subscribe(onNext: { list in
//                weakSelf?.reloadListevent.accept(list)
                debugPrint("reload item \(list.count) from local")
            }, onError: { error in
                weakSelf?.errorEvent.accept(error)
                debugPrint("\(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
}
