//
//  TransactionListViewModelTest.swift
//  HomeworkTests
//
//  Created by ClydeHsieh on 2022/5/21.
//

import XCTest
import RxSwift
import Alamofire
//import RxRelay

@testable import Homework

class TransactionListViewModelTest: XCTestCase {

    func test_request_list() {
        let (api, db, vm) = makeSUT()
        
        XCTAssertEqual(api.getListRequestCount, 0)
        XCTAssertEqual(db.insertCount, 0)
        XCTAssertEqual(db.insertItemCount, 0)
        
        api.responseMock = TransationListResponse(list: [NoteItem.mock(), NoteItem.mock()])
        
        vm.fetchList()
        XCTAssertEqual(api.getListRequestCount, 1)
        XCTAssertEqual(db.insertCount, 1)
        XCTAssertEqual(db.insertItemCount, api.responseMock!.list!.count)
    }
    
    func makeSUT() -> (apiSpy: APIManageSPY, dbMangerSPY: DBManagerSPY, viewModel: TransactionListViewModel) {
        
        let apiSpy = APIManageSPY()
        let dbMangerSPY = DBManagerSPY()
        let viewModel = TransactionListViewModel.init(apiManager: apiSpy, dbManager: dbMangerSPY)
        return (apiSpy, dbMangerSPY, viewModel)
    }
}

//MARK: - APIManageSPY
class APIManageSPY: APIManagerType {
    
    var getListRequestCount = 0
    var uploadItemRequestCount = 0
    
    var responseMock: TransationListResponse?
    
    func getTransactions() -> Observable<TransationListResponse> {
        getListRequestCount += 1
        return Observable<TransationListResponse>.create { [weak self] observer in
            if let res = self?.responseMock {
                observer.onNext(res)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func uploadNewItem(reqeust: CreateModifyRequest) -> Observable<TransationListResponse> {
        uploadItemRequestCount += 1
        return Observable<TransationListResponse>.create {  observer in
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

//MARK: - DBManagerSPY
class DBManagerSPY: DBManagerType {
    var insertCount = 0
    var insertItemCount = 0
    var loadCount = 0
    
    
    func insert(items: [NoteItem]) -> Observable<Void> {
        insertItemCount = items.count
        insertCount += 1
        return Observable<Void>.create { observer in
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func loadItems() -> Observable<[NoteItem]> {
        loadCount += 1
        return Observable<[NoteItem]>.create { observer in
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
