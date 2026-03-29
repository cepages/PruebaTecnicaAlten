//
//  UserDetailRouter.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation
import UIKit

final class UserDetailRouter: UserDetailRouterProtocol {
    
    static func createModule(with user: User) -> UIViewController {
        let view = UserDetailView()
        let interactor = UserDetailInteractor()
        let presenter = UserDetailPresenter(user: user)
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        
        presenter.router = UserDetailRouter()
        
        interactor.output = presenter
        
        return view
    }
}
