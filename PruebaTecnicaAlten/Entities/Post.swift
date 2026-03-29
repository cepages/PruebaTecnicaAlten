//
//  Post.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

struct Post: Equatable, Hashable, Sendable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
}
