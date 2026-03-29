//
//  UserDetailProtocols.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import UIKit
import Combine

// MARK: - Interactor
protocol UserDetailInteractorInputProtocol {
    func fetchPosts(for userId: Int)
}

protocol UserDetailInteractorOutputProtocol: AnyObject {
    func didFetchPosts(_ posts: [Post])
    func didFailToFetchPosts(with error: Error)
}

// MARK: - Presenter
protocol UserDetailPresenterProtocol {
    var posts: [Post] { get }
    var postsPublisher: AnyPublisher<[Post], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<String?, Never> { get }
    
    var user: User { get }
    
    func viewDidLoad()
    func dismissError()
}

// MARK: - Router
protocol UserDetailRouterProtocol {
    static func createModule(with user: User) -> UIViewController
    
    
}
