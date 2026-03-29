//
//  PostDTO.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

struct PostDTO: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension PostDTO {
    func toDomain() -> Post {
        
        return Post(
            id: id,
            userId: userId,
            title: title,
            body: body
        )
    }
}
