//
//  AccountViewModel.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import UIKit
import RxSwift

struct SignInDetails {
    let emailText: String
    let passwordText: String
}

class AccountViewModel {

    //input
    let networkService: NetworkServicing
    private var disposeBag: DisposeBag

    //output
    var queryIsValid: Observable<Bool>!
    //var passwordIsValid: Observable<Bool>!
    var searchButtonEnabled: Observable<Bool>!
    var account: Observable<Account>!


    init(networkService: NetworkServicing = NetworkService.shared, disposeBag: DisposeBag) {
        self.networkService = networkService
        self.disposeBag = disposeBag
    }

    func configure(
        queryText: Observable<String>,
        searchButtonTap: Observable<Void>) {

        // Query
        let queryRegexMatcher = RegexMatcher(regex: "[a-z1-5.]{1,12}")
            queryIsValid = queryText.map({
            return queryRegexMatcher.matches(string: $0)
        })
            
        //SignIn Button
//            searchButtonEnabled = Observable.map { queryIsValid -> Bool in
//            return queryIsValid
//            }
//            .startWith(false)

        
        account = Observable.combineLatest(queryText,
                                                queryIsValid,
                                                searchButtonTap,
                                                resultSelector: { (queryText, queryIsValid, searchButtonTap) -> String? in

                                                    guard queryIsValid else { return nil }
                                                    return queryText
        }).unwrap()
        .flatMapLatest({[weak self] searchString -> Observable<Account> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.networkService.fetchAccountDetails(accountName: searchString)
        }).take(1)
    }
}

struct RegexMatcher {
    let regex: String

    func matches(string: String) -> Bool {
        let reguralExpression = try? NSRegularExpression(pattern: regex, options: .caseInsensitive)
        return reguralExpression?.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) != nil
    }

}


extension Optional where Wrapped: StringType {
    var isEmptyOrNil: Bool {
        return self?.get.isEmpty ?? true
    }
}

protocol StringType {
    var get: String { get }
}

extension String: StringType {
    var get: String { return self }
}
