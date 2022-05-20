//
//  APIManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import Alamofire
import RxSwift

//The header fields
enum HttpHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

//The content type (JSON)
enum ContentType: String {
    case json = "application/json"
}

class APIManager {
    
    static let shared = APIManager()
    static let host:String = "https://e-app-testing-z.herokuapp.com"
    private static let transaction:String = "/transaction"
    
    private func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}


extension APIManager {
    func getTransactions() -> Observable<TransationListResponse> {
        return request(TransactionApi.getTransaction)
    }
}
