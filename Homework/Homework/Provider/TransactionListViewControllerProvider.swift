//
//  TransactionListViewControllerProvider.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit

struct TransactionListViewControllerProvider {

    static var apiManager: APIManager {
        APIManager.shared
    }
    
    static var dbManager: DBManager {
        DBManager.shared
    }
    
    static var viewModel: TransactionListViewModel {
        TransactionListViewModel(apiManager: self.apiManager, dbManager: self.dbManager)
    }
    
    static var viewController: TransactionListViewController {
        TransactionListViewController(viewModel: self.viewModel)
    }
}
