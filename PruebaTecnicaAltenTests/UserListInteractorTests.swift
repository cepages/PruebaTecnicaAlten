//
//  UserListInteractorTests.swift
//  PruebaTecnicaAltenTests
//
//  Created by Carlos Pagés on 29/03/2026.
//

import XCTest
@testable import PruebaTecnicaAlten

final class MockUserListInteractorOutput: UserListInteractorOutputProtocol {
    var didFetchUsersCalled = false
    var fetchedUsers: [User] = []
    var didFailToFetchUsersCalled = false
    var fetchError: Error?
    
    var expectation: XCTestExpectation?
    
    func didFetchUsers(_ users: [User]) {
        didFetchUsersCalled = true
        fetchedUsers = users
        expectation?.fulfill()
    }
    
    func didFailToFetchUsers(with error: Error) {
        didFailToFetchUsersCalled = true
        fetchError = error
        expectation?.fulfill()
    }
}

final class UserListInteractorTests: XCTestCase {
    
    var interactor: UserListInteractor!
    var mockNetworkService: MockNetworkService!
    var mockOutput: MockUserListInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockOutput = MockUserListInteractorOutput()
        
        interactor = UserListInteractor(networkService: mockNetworkService)
        interactor.output = mockOutput
    }
    
    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockOutput = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() {
        // Given
        let dto = UserDTO(id: 1, name: "Test User", username: "test", email: "test@test.com", address: AddressDTO(street: "Street", suite: "Apt", city: "City", zipcode: "12345"), phone: "123", website: "test.com", company: CompanyDTO(name: "Company", catchPhrase: "", bs: ""))
        mockNetworkService.fetchUsersResult = .success([dto])
        
        let expectation = XCTestExpectation(description: "Fetch Users Success")
        mockOutput.expectation = expectation
        
        // When
        interactor.fetchUsers()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockOutput.didFetchUsersCalled)
        XCTAssertEqual(mockOutput.fetchedUsers.count, 1)
        XCTAssertEqual(mockOutput.fetchedUsers.first?.name, "Test User")
    }
    
    func testFetchUsersFailure() {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        mockNetworkService.fetchUsersResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Fetch Users Failure")
        mockOutput.expectation = expectation
        
        // When
        interactor.fetchUsers()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockOutput.didFailToFetchUsersCalled)
        XCTAssertNotNil(mockOutput.fetchError)
        XCTAssertEqual(mockOutput.fetchError as NSError?, expectedError)
    }
}
