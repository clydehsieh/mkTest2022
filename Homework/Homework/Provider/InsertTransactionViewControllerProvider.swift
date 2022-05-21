//
//  InsertTransactionViewControllerProvider.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit

struct InsertTransactionViewControllerProvider {

    static var apiManager: APIManagerType {
        APIManager.shared
    }
    
    static var dbManager: DBManagerType {
        DBManager.shared
    }
    
    static var viewModel: InsertTransactionViewModel {
        InsertTransactionViewModel(apiManager: self.apiManager, dbManager: self.dbManager)
    }
    
    static var viewController: InsertTransactionViewController {
        InsertTransactionViewController(viewModel: self.viewModel)
    }
}
