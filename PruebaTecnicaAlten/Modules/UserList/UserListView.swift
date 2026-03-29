//
//  UserListView.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit

final class UserListView: UIViewController {
    
    var presenter: UserListPresenterProtocol?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .blue
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension UserListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}


