//
//  UserDetailView.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation
import UIKit
import Combine

final class UserDetailView: UIViewController {
    
    var presenter: UserDetailPresenterProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGroupedBackground
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        table.dataSource = self
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
        setupHeader()
        bindPresenter()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = presenter?.user.name ?? "Details"
        view.backgroundColor = .white
        
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
    
    private func setupHeader() {
        guard let user = presenter?.user else { return }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let labels = [
            createLabel(text: "Name: \(user.name)", isBold: true),
            createLabel(text: "Email: \(user.email)"),
            createLabel(text: "Phone: \(user.phone)"),
            createLabel(text: "Website: \(user.website)"),
            createLabel(text: "Address: \(user.city)"),
            createLabel(text: "Company: \(user.companyName)")
        ]
        
        labels.forEach { stackView.addArrangedSubview($0) }
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        headerView.frame.size.height = size.height
        
        tableView.tableHeaderView = headerView
    }
    
    private func createLabel(text: String, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isBold ? .boldSystemFont(ofSize: 18) : .systemFont(ofSize: 16)
        label.textColor = isBold ? .label : .secondaryLabel
        label.numberOfLines = 0
        return label
    }
    
    
    private func bindPresenter() {
        presenter?.postsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
            
        presenter?.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.activityIndicator.startAnimating()
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

extension UserDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell,
              let post = presenter?.posts[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: post)
        return cell
    }
}
