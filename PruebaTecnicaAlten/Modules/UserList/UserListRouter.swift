//
//  UserListRouter.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit

final class UserListRouter: UserListRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = UserListView()
        let interactor = UserListInteractor()
        let presenter = UserListPresenter()
        let router = UserListRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        return view
    }
}
