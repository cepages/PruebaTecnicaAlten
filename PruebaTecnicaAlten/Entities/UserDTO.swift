//
//  UserDTO.swift
//  PruebaTecnicaAlten
//
//  Created by Carlos Pagés on 29/03/2026.
//

import Foundation

struct UserDTO: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: AddressDTO
    let phone: String
    let website: String
    let company: CompanyDTO
}

struct AddressDTO: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct CompanyDTO: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
