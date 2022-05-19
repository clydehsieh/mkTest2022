//
//  TableView+Extension.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

import UIKit

extension UITableViewCell {
    static var className: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register(cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.className)
    }
}

extension UITableView {
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
}
