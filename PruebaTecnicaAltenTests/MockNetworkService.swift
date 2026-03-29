//
//  MockNetworkService.swift
//  PruebaTecnicaAltenTests
//
//  Created by Carlos Pagés on 29/03/2026.
//

@testable import PruebaTecnicaAlten

final class MockNetworkService: NetworkServiceProtocol {
    var fetchUsersResult: Result<[UserDTO], Error> = .success([])
    var fetchPostsResult: Result<[PostDTO], Error> = .success([])
    
    func fetchUsers() async throws -> [UserDTO] {
        switch fetchUsersResult {
        case .success(let users): return users
        case .failure(let error): throw error
        }
    }
    
    func fetchPosts(for userId: Int) async throws -> [PostDTO] {
        switch fetchPostsResult {
        case .success(let posts): return posts
        case .failure(let error): throw error
        }
    }
}

