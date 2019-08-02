//
//  Network.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

public class Network {
//    public static let shared = Network()
    
    private let config: URLSessionConfiguration
    private let session: URLSession
    
    init(config: URLSessionConfiguration, session: URLSession) {
        self.config = config//URLSessionConfiguration.default
        self.session = session//URLSession(configuration: config)
    }
    
    public func request<O: Routable, T: Decodable>(router: O, completion: @escaping (Result<T>) -> ()) {
        do {
            let task = try session.dataTask(with: router.request()) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(Result<T>.failure(error: error))
                        return
                    }
                    
                    guard let statusCode = urlResponse?.getStatusCode(), (200...299).contains(statusCode) else {
                        let errorType: ErrorType
                        
                        switch urlResponse?.getStatusCode() {
                        case 404:
                            errorType = .notFound
                        case 422:
                            errorType = .validationError
                        case 500:
                            errorType = .serverError
                        default:
                            errorType = .defaultError
                        }
                        
                        completion(Result<T>.failure(error: errorType))
                        return
                    }
                    
                    
                    guard let data = data else {
                        completion(Result<T>.failure(error: ErrorType.defaultError))
                        return
                    }
                    
                    let responseString2 = String(data: data, encoding: .utf8)
                    print("Result:\n \(String(describing: responseString2!))")
                    print();print()
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        let records = json["records"]
                        let jsonData = try JSONSerialization.data(withJSONObject: records, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(T.self, from: jsonData)
                        completion(Result.success(data: result))
                    } catch let error {
                        completion(Result.failure(error: error))
                    }
                }
            }
            task.resume()
            
        } catch let error {
            completion(Result<T>.failure(error: error))
        }
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

