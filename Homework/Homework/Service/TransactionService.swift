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
    case uploadTransaction(request: CreateModifyRequest)
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
        
        if let body = bodyParam {
            urlRequest.httpBody = body
        }
        
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
        case .getTransaction, .uploadTransaction:
            return "transaction"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTransaction:
            return .get
        case .uploadTransaction:
            return .post
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .uploadTransaction(let request):
//            return ["time": request.time, "title": request.title, "description": request.description]
            return nil
        default:
            return nil
        }
    }
    
    private var bodyParam: Data? {
        switch self {
        case .uploadTransaction(let request):
            return try? JSONEncoder().encode(request)
        default:
            return nil
        }
    }
}

