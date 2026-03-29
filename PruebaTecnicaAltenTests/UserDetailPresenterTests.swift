//
//  UserDetailPresenterTests.swift
//  PruebaTecnicaAltenTests
//
//  Created by Carlos Pagés on 29/03/2026.
//

import XCTest
import Combine
@testable import PruebaTecnicaAlten

final class MockUserDetailInteractor: UserDetailInteractorInputProtocol {
    var fetchPostsCalled = false
    var fetchedUserId: Int?
    
    func fetchPosts(for userId: Int) {
        fetchPostsCalled = true
        fetchedUserId = userId
    }
}

final class MockUserDetailRouter: UserDetailRouterProtocol {
    static func createModule(with user: User) -> UIViewController {
        return UIViewController()
    }
}

final class UserDetailPresenterTests: XCTestCase {
    
    var presenter: UserDetailPresenter!
    var interactor: MockUserDetailInteractor!
    var router: MockUserDetailRouter!
    var cancellables: Set<AnyCancellable>!
    
    let mockUser = User(id: 1, name: "Test User", email: "test@domain.com", phone: "123", website: "test.com", city: "City", companyName: "Company")
    
    override func setUp() {
        super.setUp()
        interactor = MockUserDetailInteractor()
        router = MockUserDetailRouter()
        cancellables = []
        
        presenter = UserDetailPresenter(user: mockUser)
        presenter.interactor = interactor
        presenter.router = router
    }
    
    override func tearDown() {
        presenter = nil
        interactor = nil
        router = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoadTriggersFetchPostsAndLoadingState() {
        // Given
        var isLoadingValues: [Bool] = []
        presenter.isLoadingPublisher
            .sink { isLoadingValues.append($0) }
            .store(in: &cancellables)
            
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(interactor.fetchPostsCalled)
        XCTAssertEqual(interactor.fetchedUserId, mockUser.id)
        XCTAssertEqual(isLoadingValues.last, true)
    }
    
    func testDidFetchPostsPopulatesPostsAndStopsLoading() {
        // Given
        var isLoadingValues: [Bool] = []
        presenter.isLoadingPublisher
            .sink { isLoadingValues.append($0) }
            .store(in: &cancellables)
            
        let mockPosts = [
            Post(id: 1, userId: 1, title: "Post 1", body: "Body 1"),
            Post(id: 2, userId: 1, title: "Post 2", body: "Body 2")
        ]
        
        var emittedPosts: [[Post]] = []
        presenter.postsPublisher
            .sink { emittedPosts.append($0) }
            .store(in: &cancellables)
            
        // When
        presenter.didFetchPosts(mockPosts)
        
        // Then
        XCTAssertEqual(presenter.posts.count, 2)
        XCTAssertEqual(emittedPosts.last?.count, 2)
        XCTAssertEqual(isLoadingValues.last, false)
    }
    
    func testDidFailToFetchPostsShowsError() {
        // Given
        var isLoadingValues: [Bool] = []
        presenter.isLoadingPublisher
            .sink { isLoadingValues.append($0) }
            .store(in: &cancellables)
            
        var errorMessages: [String?] = []
        presenter.errorPublisher
            .sink { errorMessages.append($0) }
            .store(in: &cancellables)
            
        let mockError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock Error occurred"])
        
        // When
        presenter.didFailToFetchPosts(with: mockError)
        
        // Then
        XCTAssertEqual(errorMessages.last ?? "", "Mock Error occurred")
        XCTAssertEqual(isLoadingValues.last, false)
    }
    
    func testDismissErrorClearsErrorState() {
        // Given
        var errorMessages: [String?] = []
        presenter.errorPublisher
            .sink { errorMessages.append($0) }
            .store(in: &cancellables)
            
        let mockError = NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"])
        presenter.didFailToFetchPosts(with: mockError)
        XCTAssertNotNil(errorMessages.last ?? nil)
        
        // When
        presenter.dismissError()
        
        // Then
        XCTAssertNil(errorMessages.last ?? "not nil")
    }
}
