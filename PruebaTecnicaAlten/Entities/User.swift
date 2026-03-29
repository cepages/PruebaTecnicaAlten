//
//  User.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

struct User: Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let website: String
    let city: String
    let companyName: String
}
