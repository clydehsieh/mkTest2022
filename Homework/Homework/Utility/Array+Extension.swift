//
//  Array+Extension.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
