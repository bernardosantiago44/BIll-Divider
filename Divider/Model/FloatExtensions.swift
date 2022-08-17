//
//  FloatExtensions.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 19/06/22.
//

import Foundation

extension Float {
    func makeCurrency(currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.currencyCode = currencyCode
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencySymbol = formatter.currencySymbol
        
        return formatter.string(from: self as NSNumber) ?? "n/a"
    }
}
