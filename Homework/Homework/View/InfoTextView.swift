//
//  InfoTextView.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

class InfoTextView: UIView {
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        return lb
    }()
    
    let contentTextFeild: UITextField = {
        let tv = UITextField()
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    var viewHierarchyNotReady = true
    
    //MARK: - lifecucle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard viewHierarchyNotReady else { return }
        isUserInteractionEnabled = true
        constructViewHierarchy()
        activateConstraints()
        viewHierarchyNotReady = false
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoTextView {
    private func constructViewHierarchy() {
        addSubview(titleLabel)
        addSubview(contentTextFeild)
    }
    
    private func activateConstraints() {   
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        contentTextFeild.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
