//
//  UserDetailPresenter.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation
import Combine

final class UserDetailPresenter: UserDetailPresenterProtocol {
    
    var interactor: UserDetailInteractorInputProtocol?
    var router: UserDetailRouterProtocol?
    
    let user: User
    
    @Published private(set) var posts: [Post] = []
    @Published private var isLoading: Bool = false
    @Published private var error: String? = nil
    
    var postsPublisher: AnyPublisher<[Post], Never> {
        $posts.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<String?, Never> {
        $error.eraseToAnyPublisher()
    }
    
    init(user: User) {
        self.user = user
    }
    
    func viewDidLoad() {
        isLoading = true
        interactor?.fetchPosts(for: user.id)
    }
    
    func dismissError() {
        error = nil
    }
    
}

extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    
    func didFetchPosts(_ posts: [Post]) {
        self.posts = posts
        isLoading = false
        if posts.isEmpty {
            self.error = "No posts found."
        }
    }
    
    func didFailToFetchPosts(with error: Error) {
        isLoading = false
        self.error = error.localizedDescription
    }
}
