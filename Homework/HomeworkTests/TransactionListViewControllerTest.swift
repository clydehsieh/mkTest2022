//
//  TransactionListViewControllerTest.swift
//  HomeworkTests
//
//  Created by ClydeHsieh on 2022/5/21.
//

import XCTest
@testable import Homework

class TransactionListViewControllerTest: XCTestCase {

    func testMemoryleak() {
        let (_, _, _, vc) = makeSUT()
        
        addTeardownBlock { [weak vc] in
            XCTAssertNil(vc, "viewcontroller should have been deallocated. Potential memory leak", file: #filePath, line: #line)
        }
    }
    
    func makeSUT() -> (apiSpy: APIManageSPY,
                       dbMangerSPY: DBManagerSPY,
                       viewModel: TransactionListViewModel,
                       vc: TransactionListViewController)
    {
        
        let apiSpy = APIManageSPY()
        let dbMangerSPY = DBManagerSPY()
        let viewModel = TransactionListViewModel.init(apiManager: apiSpy, dbManager: dbMangerSPY)
        let vc = TransactionListViewController.init(viewModel: viewModel)
        return (apiSpy, dbMangerSPY, viewModel, vc)
    }
}
