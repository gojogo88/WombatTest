//
//  Account.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation

struct Account: Decodable {
    let accountName: String
    let created: String
    let ramQuota: Int
    let netLimit, cpuLimit: Limit
    let totalResources: TotalResources
    let coreLiquidBalance: String
    let netWeight, cpuWeight, ramUsage: Int
    let voterInfo: VoterInfo
}

// MARK: - Limit
struct Limit: Decodable {
    let max, available, used: Float
}

// MARK: - TotalResources
struct TotalResources: Decodable {
    let owner, netWeight, cpuWeight: String
    let ramBytes: Double
}

// MARK: - VoterInfo
struct VoterInfo: Decodable {
    let staked: Double
}
