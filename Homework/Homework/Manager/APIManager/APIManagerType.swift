//
//  APIManagerType.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/21.
//

import UIKit
import RxSwift

protocol APIManagerType {
    func getTransactions() -> Observable<TransationListResponse>
    func uploadNewItem(reqeust: CreateModifyRequest) -> Observable<TransationListResponse>
}
