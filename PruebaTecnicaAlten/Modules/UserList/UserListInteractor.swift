//
//  UserListInteractor.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

final class UserListInteractor: UserListInteractorInputProtocol {
    weak var output: UserListInteractorOutputProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchUsers() {
        Task {
            do {
                let dtos = try await networkService.fetchUsers()
                let users = dtos.map { $0.toDomain() }
                await MainActor.run {
                    self.output?.didFetchUsers(users)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailToFetchUsers(with: error)
                }
            }
        }
    }

}

