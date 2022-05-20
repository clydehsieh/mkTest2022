//
//  TransactionService.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
//

import UIKit
import Alamofire
import RxSwift

enum TransactionApi {
    case getTransaction
}

extension TransactionApi: URLRequestConvertible {

    func asURLRequest() throws -> URLRequest {
        let url = try APIManager.host.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    var path: String {
        switch self {
        case .getTransaction:
            return "transaction"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getTransaction:
            return .get
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
}

