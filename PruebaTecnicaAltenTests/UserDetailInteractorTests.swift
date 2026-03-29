//
//  UserDetailInteractorTests.swift
//  PruebaTecnicaAltenTests
//
//  Created by Carlos Pagés on 29/03/2026.
//

import XCTest
@testable import PruebaTecnicaAlten

final class MockUserDetailInteractorOutput: UserDetailInteractorOutputProtocol {
    var didFetchPostsCalled = false
    var fetchedPosts: [Post] = []
    var didFailToFetchPostsCalled = false
    var fetchError: Error?
    
    var expectation: XCTestExpectation?
    
    func didFetchPosts(_ posts: [Post]) {
        didFetchPostsCalled = true
        fetchedPosts = posts
        expectation?.fulfill()
    }
    
    func didFailToFetchPosts(with error: Error) {
        didFailToFetchPostsCalled = true
        fetchError = error
        expectation?.fulfill()
    }
}

final class UserDetailInteractorTests: XCTestCase {
    
    var interactor: UserDetailInteractor!
    var mockNetworkService: MockNetworkService!
    var mockOutput: MockUserDetailInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockOutput = MockUserDetailInteractorOutput()
        
        interactor = UserDetailInteractor(networkService: mockNetworkService)
        interactor.output = mockOutput
    }
    
    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockOutput = nil
        super.tearDown()
    }
    
    func testFetchPostsSuccess() {
        // Given
        let dto = PostDTO(userId: 1, id: 1, title: "Title", body: "Body")
        mockNetworkService.fetchPostsResult = .success([dto])
        
        let expectation = XCTestExpectation(description: "Fetch Posts Success")
        mockOutput.expectation = expectation
        
        // When
        interactor.fetchPosts(for: 1)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockOutput.didFetchPostsCalled)
        XCTAssertEqual(mockOutput.fetchedPosts.count, 1)
        XCTAssertEqual(mockOutput.fetchedPosts.first?.title, "Title")
    }
    
    func testFetchPostsFailure() {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        mockNetworkService.fetchPostsResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Fetch Posts Failure")
        mockOutput.expectation = expectation
        
        // When
        interactor.fetchPosts(for: 1)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockOutput.didFailToFetchPostsCalled)
        XCTAssertNotNil(mockOutput.fetchError)
        XCTAssertEqual(mockOutput.fetchError as NSError?, expectedError)
    }
}
