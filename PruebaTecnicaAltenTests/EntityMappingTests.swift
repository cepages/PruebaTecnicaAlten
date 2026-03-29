//
//  EntityMappingTests.swift
//  PruebaTecnicaAltenTests
//
//  Created by Carlos Pagés on 29/03/2026.
//

import XCTest
@testable import PruebaTecnicaAlten

final class EntityMappingTests: XCTestCase {
    
    func testUserDTOToDomainMapping() {
        // Given
        let companyDTO = CompanyDTO(name: "Test Company", catchPhrase: "Testing", bs: "BS")
        let addressDTO = AddressDTO(street: "Main St", suite: "Apt 1", city: "Tech City", zipcode: "12345")
        let userDTO = UserDTO(
            id: 1,
            name: "John Doe",
            username: "johndoe",
            email: "john@example.com",
            address: addressDTO,
            phone: "555-1234",
            website: "example.com",
            company: companyDTO
        )
        
        // When
        let user = userDTO.toDomain()
        
        // Then
        XCTAssertEqual(user.id, userDTO.id)
        XCTAssertEqual(user.name, userDTO.name)
        XCTAssertEqual(user.email, userDTO.email)
        XCTAssertEqual(user.phone, userDTO.phone)
        XCTAssertEqual(user.website, userDTO.website)
        XCTAssertEqual(user.city, userDTO.address.city)
        XCTAssertEqual(user.companyName, userDTO.company.name)
    }
    
    func testPostDTOToDomainMapping() {
        // Given
        let postDTO = PostDTO(
            userId: 1,
            id: 10,
            title: "Test Title",
            body: "Test Body Content"
        )
        
        // When
        let post = postDTO.toDomain()
        
        // Then
        XCTAssertEqual(post.id, postDTO.id)
        XCTAssertEqual(post.userId, postDTO.userId)
        XCTAssertEqual(post.title, postDTO.title)
        XCTAssertEqual(post.body, postDTO.body)
    }
}

