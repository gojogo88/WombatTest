//
//  NetworkService.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation
import RxSwift

final class NetworkService: NetworkServicing {

    // MARK: - Properties
    public static let shared = NetworkService()
    private init() {}
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    // MAKR: - Method
    func fetchAccountDetails(accountName: String) -> Observable<Account> {
        
        let parameter: [String: String] = ["account_name": accountName]
        
        guard let url = URL(string: "https://eos.greymass.com/v1/chain/get_account") else { preconditionFailure("invalid endpoint") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                if error != nil {
                    observer.onError(AccountError.apiError)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(AccountError.invalidResponse)
                    return
                }
                
                guard let data = data else {
                    observer.onError(AccountError.invalidData)
                    return
                }
                
                do {
                    let account = try self.jsonDecoder.decode(Account.self, from: data)
                    observer.onNext(account)
                } catch {
                    observer.onError(AccountError.serializationError)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
