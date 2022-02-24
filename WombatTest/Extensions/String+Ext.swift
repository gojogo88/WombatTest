//
//  String+Ext.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import Foundation

extension String {
    func isValid() -> Bool {
        let format = "SELF MATCHES %@"
        let regex = "[a-z1-5.]{1,12}"
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
