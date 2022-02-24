//
//  HttpClient.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation
import RxSwift
import RxCocoa


class HttpClient {
    let session: URLSession

    static var sharedService = HttpClient(URLSession: URLSession.shared)

    init(URLSession: Foundation.URLSession) {
        self.session = URLSession
    }
}
