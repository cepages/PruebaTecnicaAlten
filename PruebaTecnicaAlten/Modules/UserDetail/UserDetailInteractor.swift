//
//  UserDetailInteractor.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

final class UserDetailInteractor: UserDetailInteractorInputProtocol {
    
    weak var output: UserDetailInteractorOutputProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPosts(for userId: Int) {
        Task {
            do {
                let dtos = try await networkService.fetchPosts(for: userId)
                let posts = dtos.map { $0.toDomain() }
                await MainActor.run {
                    self.output?.didFetchPosts(posts)
                }
                
            } catch {
                await MainActor.run {
                    self.output?.didFailToFetchPosts(with: error)
                }
            }
        }
    }
}
