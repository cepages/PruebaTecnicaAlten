//
//  UserListPresenter.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit
import Combine

final class UserListPresenter: UserListPresenterProtocol {
    weak var view: UIViewController?
    var interactor: UserListInteractorInputProtocol?
    var router: UserListRouterProtocol?
    
    @Published private(set) var users: [User] = []
    @Published private var isLoading: Bool = false
    @Published private var error: String? = nil
    
    var usersPublisher: AnyPublisher<[User], Never> {
        $users.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<String?, Never> {
        $error.eraseToAnyPublisher()
    }
    
    // MARK: - UserListPresenterProtocol
    
    func viewDidLoad() {
        isLoading = true
        interactor?.fetchUsers()
    }
    
    func dismissError() {
        error = nil
    }
}

extension UserListPresenter: UserListInteractorOutputProtocol {
    func didFetchUsers(_ users: [User]) {
        self.users = users
        isLoading = false
        if users.isEmpty {
            self.error = "No users found."
        }
    }
    
    func didFailToFetchUsers(with error: Error) {
        isLoading = false
        self.error = error.localizedDescription
    }
}

