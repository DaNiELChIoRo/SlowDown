//
//  Router.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

public enum HTTPMethod {
    case get
    case post
    case put
    case delete
    case patch
    
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        }
    }
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public protocol Router {
    associatedtype R: Codable
    var baseURL: String { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var body: R? { get }
    var headers: HTTPHeaders? { get }
    var authField: String? { get }
}

public protocol Routable: Router {
    
    
}

extension Routable{
    var parameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authField: String? {
        return nil
    }
    
    var body: R? {
        return nil
    }
    
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "base_url") as! String
    }
    
    func request() throws -> URLRequest {
        let urlString = "\(baseURL)\(endPoint)"
        
        guard let url = URL(string: urlString) else {
            throw ErrorType.parseUrlFail
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.value// set HTTP Method
        
        if let hFields = headers { // Add headers if the router have headers
            for (header, value) in hFields {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        
        if let auth = authField { // Add authField if the router have an auth
            request.setValue(auth, forHTTPHeaderField: "Authorization")
        }
        
        switch method {
        case .post, .put, .patch, .delete:
            if let bodyObject = try? JSONEncoder().encode(body) {
                request.httpBody = bodyObject
                
                if let str = String(data: bodyObject, encoding: String.Encoding.utf8) as String? {
                    print("param: \(str)")
                }
            }
        default:
            var urlComp = URLComponents(string: url.absoluteString)!
            var items = [URLQueryItem]()
            
            if let bodyObject = try? JSONEncoder().encode(body), let params  = try? JSONSerialization.jsonObject(with: bodyObject, options: []) as? [String: String] {
                for (key,value) in params {
                    items.append(URLQueryItem(name: key, value: value))
                }
            }
            items = items.filter{!$0.name.isEmpty}
            urlComp.queryItems = items
            request.url = urlComp.url
        }
        
        return request
    }
}
