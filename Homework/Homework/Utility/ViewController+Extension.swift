//
//  ViewController+Extension.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/21.
//

import UIKit

extension UIViewController {
    func addTapToDismissKeyboardGesture() {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(endViewsEditing))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    func endViewsEditing() {
        view.endEditing(true)
    }
}
