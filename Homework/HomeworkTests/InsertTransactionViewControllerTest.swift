//
//  InsertTransactionViewControllerTest.swift
//  HomeworkTests
//
//  Created by ClydeHsieh on 2022/5/21.
//

import XCTest
@testable import Homework

class InsertTransactionViewControllerTest: XCTestCase {

    func testMemoryleak() {
        let vc = makeSUT()
        addTeardownBlock { [weak vc] in
            XCTAssertNil(vc, "viewcontroller should have been deallocated. Potential memory leak", file: #filePath, line: #line)
        }
    }
    
    
    func makeSUT() -> InsertTransactionViewController {
        InsertTransactionViewControllerProvider.viewController
    }
}
