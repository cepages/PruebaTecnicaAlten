//
//  UserListView.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit
import Combine

final class UserListView: UIViewController {
    
    var presenter: UserListPresenterProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGroupedBackground
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.register(UserListCell.self, forCellReuseIdentifier: UserListCell.reuseIdentifier)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Users"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindPresenter() {
        presenter?.usersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
                
                if let isEmpty = self.presenter?.users.isEmpty, !isEmpty {
                    self.tableView.isHidden = false
                }
            }
            .store(in: &cancellables)
            
        presenter?.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.tableView.isHidden = true
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
            
        presenter?.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorString in
                guard let self = self else { return }
                if let errorMessage = errorString {
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.presenter?.dismissError()
                    }))
                    self.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension UserListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.reuseIdentifier, for: indexPath) as? UserListCell,
              let user = presenter?.users[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: user)
        return cell
    }
}


