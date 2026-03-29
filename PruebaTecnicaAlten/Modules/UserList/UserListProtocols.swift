//
//  UserListProtocols.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit

// MARK: - Interactor
protocol UserListInteractorInputProtocol {
    
}

protocol UserListInteractorOutputProtocol: AnyObject {

}

// MARK: - Presenter
protocol UserListPresenterProtocol {

}

// MARK: - Router
protocol UserListRouterProtocol {
    static func createModule() -> UIViewController
}
