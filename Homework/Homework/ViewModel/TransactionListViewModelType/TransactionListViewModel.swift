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
    var reloadTotalCost = PublishRelay<Int>()
    
    //MARK: - DI
    let apiManager: APIManager
    let dbManager: DBManager
    
    //MARK: - param
    var disposbag = DisposeBag()
    
    init(apiManager: APIManager, dbManager: DBManager) {
        self.apiManager = apiManager
        self.dbManager = dbManager
    }
    
    private func sumAndUpdateTotalCost(of lists: [NoteItem]) {
        var cost = 0
        for item in lists {
            for detail in item.details ?? [] {
                cost += detail.price * detail.quantity
            }
        }
        
        reloadTotalCost.accept(cost)
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
                debugPrint("fetch \(list.count) items from server")
                weakSelf?.saveToLocalDB(items: list)
            }, onError: { error in
                weakSelf?.errorEvent.accept(error)
                weakSelf?.loadFromLocalDB()
                debugPrint("\(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
    
    func saveToLocalDB(items: [NoteItem]) {
        weak var weakSelf = self
        dbManager.insert(items: items)
            .subscribe(onNext: {
                debugPrint("did sync server data with to local db")
                weakSelf?.loadFromLocalDB()
            }, onError: { error in
                weakSelf?.errorEvent.accept(error)
                weakSelf?.loadFromLocalDB()
                debugPrint("fail to sync server data with to local db \(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
    
    func loadFromLocalDB() {
        weak var weakSelf = self
        dbManager.loadItems()
            .subscribe(onNext: { list in
                weakSelf?.reloadListevent.accept(list)
                weakSelf?.sumAndUpdateTotalCost(of: list)
                debugPrint("fetch \(list.count) items from local db")
            }, onError: { error in
                weakSelf?.errorEvent.accept(error)
                debugPrint("fail to fetch data from local db: \(error.localizedDescription)")
            })
            .disposed(by: disposbag)
    }
}
