//
//  UserListPresenter.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit

final class UserListPresenter: UserListPresenterProtocol {
    weak var view: UIViewController?
    var interactor: UserListInteractorInputProtocol?
    var router: UserListRouterProtocol?
}

extension UserListPresenter: UserListInteractorOutputProtocol {
    
}

