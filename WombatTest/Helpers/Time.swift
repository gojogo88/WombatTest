//
//  Time.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation

public struct Time {
    public let microseconds: Float
    
    public var milliseconds: Float {
       return (round(microseconds * 100) / 100.0) / 1000
    }
    
    public var seconds: Float {
        return (round(microseconds * 100) / 100.0) / 1000_000
    }
    
    public func timeInString() -> String {
        switch microseconds {
        case 0...1_000:
            return "\(microseconds) microseconds"
        case 1_001...1_000_000:
            return "\(String(format: "%.2f", milliseconds)) ms"
        case 1_000_001...:
            return "\(String(format: "%.2f", seconds)) ms"
        default:
            return "\(microseconds) microseconds"
        }
    }
}
