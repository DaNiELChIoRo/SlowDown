//
//  NetworkResult.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(data: T)
    case failure(error: Error)
}
