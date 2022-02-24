//
//  NetworkServicing.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation
import RxSwift

protocol NetworkServicing {
    func fetchAccountDetails(accountName: String) -> Observable<Account>
}

public enum AccountError: Error {
    case apiError
    case invalidData
    case invalidResponse
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidData: return "Invalid data"
        case .invalidResponse: return "Invalid response"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

