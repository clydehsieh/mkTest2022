//
//  ToString+Extension.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/21.
//

import UIKit

extension Int {
    var toCurrencyString: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber.init(value: self) )
    }
}
