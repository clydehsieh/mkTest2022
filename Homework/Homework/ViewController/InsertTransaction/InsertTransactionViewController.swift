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
    
    //MARK: - DI
    let viewModel: InsertTransactionViewModel
    var completion: (([NoteItem])->Void)?
    
    //MARK: - param
    var disposbag = DisposeBag()
    var datasource = BehaviorRelay<[NoteItemDetailTableViewCellViewModel]>(value: [])
    
    //MARK: - lifecycle
    
    init(viewModel: InsertTransactionViewModel) {
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
        setupUI()
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
    
    private func setupUI() {
        timeInfoTextView.contentTextFeild.text = viewModel.time.value.yymmdd
        titleInfoTextView.contentTextFeild.text = viewModel.title.value
        descInfoTextView.contentTextFeild.text = viewModel.description.value
    }
    
    private func setupBinding() {
        // tell viewModel to insert new detail
        addDetailButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.insertNewDetail()
            })
            .disposed(by: disposbag)
        
        // start to upload
        addNoteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.uploadCreation()
            })
            .disposed(by: disposbag)
        
        // bind textField with viewModel
        titleInfoTextView.contentTextFeild.rx.text
            .map({ $0 ?? "" })
            .bind(to: viewModel.title)
            .disposed(by: disposbag)
        
        // bind textField with viewModel
        descInfoTextView.contentTextFeild.rx.text
            .map({ $0 ?? "" })
            .bind(to: viewModel.description)
            .disposed(by: disposbag)
        
        // update tableview
        datasource
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposbag)
        
        //
        viewModel.finishedUploadEvent
            .subscribe { [weak self] list in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.completion?(list)
                }
            } onError: { error in
                debugPrint("error \(error.localizedDescription)")
            }
            .disposed(by: disposbag)
        
        // did insert new detail
        viewModel.details
            .subscribe { [weak self] detailList in
                self?.datasource.accept(detailList)
            } onError: { error in
                debugPrint("error \(error.localizedDescription)")
            }
            .disposed(by: disposbag)
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
