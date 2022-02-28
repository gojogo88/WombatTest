//
//  AccountViewModel.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation
import RxSwift
import RxCocoa


final class AccountViewModel {
    
    private let networkService: NetworkServicing!
    let title = "EOS"
    
    private let _alertMessage = PublishSubject<String>()
    let alertMessage: Observable<String>
    
    init(networkService: NetworkServicing = NetworkService.shared) {
        self.networkService = networkService
        self.alertMessage = _alertMessage.asObservable()
    }
    
    func getAccount(_ accountName: String) -> Observable<Account> {
        return networkService.fetchAccountDetails(accountName: accountName)
            .catch { [weak self] error in
                self?._alertMessage.onNext(error.localizedDescription)
                return Observable.empty()
            }
    }
    
    func fetchViewModel(trigger: Observable<Void>, text: Observable<String?>) -> Observable<String> {
        trigger
            .withLatestFrom(text.map { $0 ?? "" })
            .filter { $0.isValid() }
    }
    
    func accountNameViewModel(account: Observable<Account>) -> Observable<String> {
        account.map { $0.accountName }
    }
    
    func totalBalanceViewModel(account: Observable<Account>) -> Observable<String> {
        account.map { $0.coreLiquidBalance }
    }
    
    func netValueViewModel(account: Observable<Account>) -> Observable<String> {
        account.map {
            let nMax = Int64(Int($0.netLimit.max))
            let nMaxString = Units(bytes: nMax).getReadableUnit()
            
            let nUsed = Int64(Int($0.netLimit.used))
            let nUsedString = Units(bytes: nUsed).getReadableUnit()
            
            return "NET used - \(nUsedString) / \(nMaxString)"
        }
    }
    
    func ramValueViewModel(account: Observable<Account>) -> Observable<String> {
        account.map {
            let ramUsed = Int64(Int($0.ramUsage))
            let ramUsedString = Units(bytes: ramUsed).getReadableUnit()
            
            let ramMax = Int64(Int($0.ramQuota))
            let ramMaxString = Units(bytes: ramMax).getReadableUnit()
            
            return "RAM used - \(ramUsedString) / \(ramMaxString)"
        }
    }
    
    func cpuValueViewModel(account: Observable<Account>) -> Observable<String> {
        account.map {
            let cpuMax = Float($0.cpuLimit.max)
            let cpuMaxString = Time(microseconds: cpuMax).timeInString()
            
            let cpuUsed = Float($0.cpuLimit.used)
            let cpuUsedString = Time(microseconds: cpuUsed).timeInString()
            
            return "CPU used - \(cpuUsedString) / \(cpuMaxString)"
        }
    }
}
