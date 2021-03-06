//
//  TransactionListViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import RxCocoa

class TransactionListViewController: UIViewController {
    //MARK: views
    private let sumCostLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14, weight: .bold)
        lb.text = "Loading..."
        return lb
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    private let addNoteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        btn.isHidden = true
        return btn
    }()
    
    
    //MARK: - DI
    let viewModel: TransactionListViewModel
    
    //MARK: - param
    let totalCost: BehaviorRelay<Int> = .init(value: 0)
    let datasource: BehaviorRelay<[NoteItem]> = .init(value: [])
    var disposbag = DisposeBag()
    
    //MARK: - lifecycle
    init(viewModel: TransactionListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.fetchList()
    }
}

//MARK: - configurations
extension TransactionListViewController {
    private func constructViewHierarchy() {
        view.addSubview(sumCostLabel)
        view.addSubview(tableView)
        view.addSubview(addNoteButton)
    }
    
    private func activateConstraints() {
        sumCostLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sumCostLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview()
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.size.equalTo(50)
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(cellClass: NoteItemTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBinding() {
        datasource
            .subscribe(onNext: { [weak self] itemList in
                self?.addNoteButton.isHidden = false
                self?.tableView.reloadData()
            })
            .disposed(by: disposbag)
        
        
        addNoteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presentInsertTransactionViewController()
            })
            .disposed(by: disposbag)
        
        viewModel.reloadListevent
            .subscribe(onNext: { [weak self] list in
                self?.datasource.accept(list)
            })
            .disposed(by: disposbag)
        
        viewModel.reloadTotalCost
            .subscribe(onNext: { [weak self] totalCost in
                self?.sumCostLabel.text = "????????? \(totalCost.toCurrencyString ?? "$0")"
            })
            .disposed(by: disposbag)
    }
}

//MARK-
extension TransactionListViewController {
    private func presentInsertTransactionViewController() {
        let vc = InsertTransactionViewControllerProvider.viewController
        vc.completion = { [weak self] list in
            debugPrint("upload success and save/update \(list.count) items to local db")
            self?.viewModel.saveToLocalDB(items: list)
        }
        
        vc.reloadHandler = { [weak self]  in
            debugPrint("upload fail but save item to local db success")
            self?.viewModel.loadFromLocalDB()
        }
        present(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = datasource.value[safe: indexPath.row] else {
            fatalError()
        }
        let cell: NoteItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: data)
        return cell
    }
}


//MARK: - UITableViewDataSource
extension TransactionListViewController: UITableViewDelegate {
    
}

extension TransactionListViewController {
    func mockData() -> [NoteItem] {
        [NoteItem.mock(), NoteItem.mock(), NoteItem.mock(), NoteItem.mock(), NoteItem.mock()]
    }
}
