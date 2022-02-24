//
//  NetworkServicing.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation

protocol NetworkServicing {
    func fetchAccountDetails(accountName: String) -> Observable<Account>
}
