//
//  UserListProtocols.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit
import Combine

// MARK: - Interactor
protocol UserListInteractorInputProtocol {
    func fetchUsers()
}

protocol UserListInteractorOutputProtocol: AnyObject {
    func didFetchUsers(_ users: [User])
    func didFailToFetchUsers(with error: Error)
}

// MARK: - Presenter
protocol UserListPresenterProtocol {
    var users: [User] { get }
    var usersPublisher: AnyPublisher<[User], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<String?, Never> { get }
    
    func viewDidLoad()
    func dismissError()
    
    func didSelectUser(_ user: User)
}

// MARK: - Router
protocol UserListRouterProtocol {

    static func createModule() -> UIViewController
    
    func navigateToUserDetail(from view: UIViewController, with user: User)
}
