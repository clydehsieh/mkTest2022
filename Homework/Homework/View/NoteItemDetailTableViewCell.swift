//
//  NoteItemDetailTableViewCell.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/19.
//

import UIKit
import RxCocoa
import RxSwift

class NoteItemDetailTableViewCell: UITableViewCell {
    //MARK: - views
    let nameInfoTextView = InfoTextView(title: "Detail Name: ")
    let priceInfoTextView: InfoTextView = {
        let v = InfoTextView(title: "Detail Price: ")
        v.contentTextFeild.keyboardType = .numberPad
        return v
    }()
    
    let quantityInfoTextView: InfoTextView = {
        let v = InfoTextView(title: "Detail Quantity: ")
        v.contentTextFeild.keyboardType = .numberPad
        return v
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameInfoTextView, quantityInfoTextView, priceInfoTextView])
        sv.axis = .vertical
        return sv
    }()
    
    //MARK: - param
    var viewHierarchyNotReady = true
    var disposeBag = DisposeBag()

    
    //MARK: -
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
        selectionStyle = .none
        constructViewHierarchy()
        activateConstraints()
        viewHierarchyNotReady = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(viewModel: NoteItemDetailTableViewCellViewModel) {
        nameInfoTextView.contentTextFeild.text = viewModel.name.value
        priceInfoTextView.contentTextFeild.text = viewModel.price.value > 0 ?  "\(viewModel.price.value)" : ""
        quantityInfoTextView.contentTextFeild.text = viewModel.quantity.value > 0 ? "\(viewModel.quantity.value)" : ""
        
        nameInfoTextView.contentTextFeild.rx.text
            .orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        priceInfoTextView.contentTextFeild.rx.text
            .orEmpty
            .compactMap({ Int($0) })
            .filter({ $0 >= 0})
            .bind(to: viewModel.price)
            .disposed(by: disposeBag)
        
        quantityInfoTextView.contentTextFeild.rx.text
            .orEmpty
            .compactMap({ Int($0) })
            .filter({ $0 >= 0})
            .bind(to: viewModel.quantity)
            .disposed(by: disposeBag)
    }
}

extension NoteItemDetailTableViewCell {
    private func constructViewHierarchy() {
        contentView.addSubview(stackView)
    }
    
    private func activateConstraints() {
        for view in stackView.arrangedSubviews {
            view.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        
        }
    }
}
