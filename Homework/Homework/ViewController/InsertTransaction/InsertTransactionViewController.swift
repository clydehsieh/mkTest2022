//
//  InsertTransactionViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import RxCocoa
import RxSwift

class InsertTransactionViewController: UIViewController {
    let timeInfoTextView:InfoTextView = InfoTextView(title: "Time: ")
    let titleInfoTextView = InfoTextView(title: "Title: ")
    let descInfoTextView = InfoTextView(title: "Description: ")
    
    lazy var infoTextViewStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [timeInfoTextView, titleInfoTextView, descInfoTextView])
        sv.axis = .vertical
        return sv
    }()
    
    private let addDetailButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Insert NewDetail", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.backgroundColor = .blue
        return btn
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    private let addNoteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.backgroundColor = .red
        return btn
    }()
    
    //MARK: - param
    var disposbag = DisposeBag()
    var datasource = BehaviorRelay<[NoteItemDetailTableViewCellViewModel]>(value: [])
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constructViewHierarchy()
        activateConstraints()
        configureTableView()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

//MARK: - configuration
extension InsertTransactionViewController {
    private func constructViewHierarchy() {
        view.addSubview(infoTextViewStackView)
        view.addSubview(addDetailButton)
        view.addSubview(tableView)
        view.addSubview(addNoteButton)
    }
    
    private func activateConstraints() {
        infoTextViewStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        addDetailButton.snp.makeConstraints { make in
            make.top.equalTo(infoTextViewStackView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addDetailButton.snp.bottom).offset(5)
            make.bottom.equalTo(addNoteButton.snp.top).inset(5)
            make.left.right.equalToSuperview()
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(cellClass: NoteItemDetailTableViewCell.self)
        tableView.dataSource = self
    }
    
    private func setupBinding() {
        addDetailButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                self?.insertEmptyModel()
            })
            .disposed(by: disposbag)
        
        addNoteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposbag)
        
        datasource
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposbag)
    }
}

extension InsertTransactionViewController {
    private func insertEmptyModel() {
        var current = datasource.value
        current.insert(NoteItemDetailTableViewCellViewModel(), at: 0)
        datasource.accept(current)
    }
}

//MARK: - UITableViewDataSource
extension InsertTransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = datasource.value[safe: indexPath.row] else {
            fatalError()
        }
        
        let cell: NoteItemDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(viewModel: viewModel)
        return cell
    }
}
