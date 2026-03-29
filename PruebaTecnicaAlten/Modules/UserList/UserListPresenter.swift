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
        let mockUsers = [
            User(id: 1, name: "Leanne Graham", email: "sincere@april.biz", phone: "1-770-736-8031 x56442", website: "hildegard.org", city: "Gwenborough", companyName: "Romaguera-Crona"),
            User(id: 2, name: "Ervin Howell", email: "shanna@melissa.tv", phone: "010-692-6593 x09125", website: "anastasia.net", city: "Wisokyburgh", companyName: "Deckow-Crist")
        ]
        
        users = mockUsers
        isLoading = false

    }
    
    func dismissError() {
        error = nil
    }
}

extension UserListPresenter: UserListInteractorOutputProtocol {
    
}

