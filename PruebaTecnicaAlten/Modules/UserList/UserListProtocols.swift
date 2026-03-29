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
    
}

protocol UserListInteractorOutputProtocol: AnyObject {

}

// MARK: - Presenter
protocol UserListPresenterProtocol {
    var users: [User] { get }
    var usersPublisher: AnyPublisher<[User], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<String?, Never> { get }
    
    func viewDidLoad()
    func dismissError()
}

// MARK: - Router
protocol UserListRouterProtocol {
    static func createModule() -> UIViewController
}
