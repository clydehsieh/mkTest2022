//
//  Date+Extension.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = .current
    df.calendar = Calendar(identifier: .gregorian)
    df.locale = .current
    return df
}()

extension Date {
    /// 2022/04/12 
    var yymmdd: String {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
}
