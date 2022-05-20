//
//  InsertTransactionViewControllerProvider.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit

struct InsertTransactionViewControllerProvider {

    static var apiManager: APIManager {
        APIManager.shared
    }
    
    static var viewModel: InsertTransactionViewModel {
        InsertTransactionViewModel(apiManager: self.apiManager)
    }
    
    static var viewController: InsertTransactionViewController {
        InsertTransactionViewController(viewModel: self.viewModel)
    }
}