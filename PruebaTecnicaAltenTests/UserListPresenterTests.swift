//
//  UserListPresenterTests.swift
//  PruebaTecnicaAltenTests
//
//  Created by Carlos Pagés on 29/03/2026.
//

import XCTest
import Combine
@testable import PruebaTecnicaAlten

final class MockUserListInteractor: UserListInteractorInputProtocol {
    var fetchUsersCalled = false
    
    func fetchUsers() {
        fetchUsersCalled = true
    }
}

final class MockUserListRouter: UserListRouterProtocol {
    static func createModule() -> UIViewController {
        return UIViewController()
    }
    
    var navigateToUserDetailCalled = false
    var navigatedUser: User?
    
    func navigateToUserDetail(from view: UIViewController, with user: User) {
        navigateToUserDetailCalled = true
        navigatedUser = user
    }
}

final class UserListPresenterTests: XCTestCase {
    
    var presenter: UserListPresenter!
    var interactor: MockUserListInteractor!
    var router: MockUserListRouter!
    var view: UIViewController!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        interactor = MockUserListInteractor()
        router = MockUserListRouter()
        view = UIViewController()
        cancellables = []
        
        presenter = UserListPresenter()
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
    }
    
    override func tearDown() {
        presenter = nil
        interactor = nil
        router = nil
        view = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoadTriggersFetchUsersAndLoadingState() {
        // Given
        var isLoadingValues: [Bool] = []
        presenter.isLoadingPublisher
            .sink { isLoadingValues.append($0) }
            .store(in: &cancellables)
            
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(interactor.fetchUsersCalled)
        XCTAssertEqual(isLoadingValues.last, true)
    }
    
    func testDidFetchUsersPopulatesUsersAndStopsLoading() {
        // Given
        var isLoadingValues: [Bool] = []
        presenter.isLoadingPublisher
            .sink { isLoadingValues.append($0) }
            .store(in: &cancellables)
            
        let mockUsers = [
            User(id: 1, name: "Leanne Graham", email: "sincere@april.biz", phone: "1-770-736-8031 x56442", website: "hildegard.org", city: "Gwenborough", companyName: "Romaguera-Crona"),
            User(id: 2, name: "Ervin Howell", email: "shanna@melissa.tv", phone: "010-692-6593 x09125", website: "anastasia.net", city: "Wisokyburgh", companyName: "Deckow-Crist")
        ]
        var emittedUsers: [[User]] = []
        presenter.usersPublisher
            .sink { emittedUsers.append($0) }
            .store(in: &cancellables)
            
        // When
        presenter.didFetchUsers(mockUsers)
        
        // Then
        XCTAssertEqual(presenter.users.count, 2)
        XCTAssertEqual(emittedUsers.last?.count, 2)
        XCTAssertEqual(isLoadingValues.last, false)
    }
    
    func testDidSelectUserTriggersRouting() {
        // Given
        let mockUser = User(id: 1, name: "Leanne Graham", email: "sincere@april.biz", phone: "1-770-736-8031 x56442", website: "hildegard.org", city: "Gwenborough", companyName: "Romaguera-Crona")
        
        // When
        presenter.didSelectUser(mockUser)
        
        
        // Then
        XCTAssertTrue(router.navigateToUserDetailCalled)
        XCTAssertEqual(router.navigatedUser?.id, 1)
    }
    
    func testDidFailToFetchUsersShowsError() {
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
        presenter.didFailToFetchUsers(with: mockError)
        
        // Then
        XCTAssertEqual(errorMessages.last ?? "", "Mock Error occurred")
        XCTAssertEqual(isLoadingValues.last, false)
    }
}

