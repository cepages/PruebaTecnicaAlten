//
//  NetworkService.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
}

protocol NetworkServiceProtocol {
    
    func fetchUsers() async throws -> [UserDTO]
    
    func fetchPosts(for userId: Int) async throws -> [PostDTO]
}

final class NetworkService: NetworkServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchUsers() async throws -> [UserDTO] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let users = try JSONDecoder().decode([UserDTO].self, from: data)
                return users
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func fetchPosts(for userId: Int) async throws -> [PostDTO] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(userId)") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let posts = try JSONDecoder().decode([PostDTO].self, from: data)
                return posts
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
