//
//  NoteItemTableViewCell.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit

class NoteItemTableViewCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        return lb
    }()
    
    private let detailStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    var viewHierarchyNotReady = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard viewHierarchyNotReady else { return }
        constructViewHierarchy()
        activateConstraints()
        viewHierarchyNotReady = false
    }
}

extension NoteItemTableViewCell {
    private func constructViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailStackView)
    }
    
    private func activateConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.equalTo(20)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().inset(5)
            make.right.lessThanOrEqualToSuperview()
        }
    }
}
extension NoteItemTableViewCell {
    func configure(with item: NoteItem) {
        titleLabel.text = item.displayDescription
        
        for view in detailStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for detail in (item.details ?? []) {
            let lb = createDetailLabel()
            lb.text = detail.displayDescription
            detailStackView.addArrangedSubview(lb)
        }
    }
    
    func createDetailLabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        lb.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
        return lb
    }
}
