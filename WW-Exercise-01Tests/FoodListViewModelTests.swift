//
//  LTKListViewModelTests.swift
//  WW-Exercise-01Tests
//
//  
//  
//

import XCTest
import Combine
@testable import WW_Exercise_01

final class FoodListViewModelTests: XCTestCase {

    func testViewModelLoad_invalid() {
        let mockStore = MockFoodListStore_Invalid()
        let mockLTKListViewModelSubscriber = MockLTKListViewModelSubscriber()
        let viewModelStub = LTKListViewModel(store: mockStore)

        XCTAssertFalse(mockLTKListViewModelSubscriber.hasSubscriber)
        viewModelStub.ltkEntitySubject.subscribe(mockLTKListViewModelSubscriber)
        XCTAssertTrue(mockLTKListViewModelSubscriber.hasSubscriber)

        viewModelStub.loadData()
        XCTAssertTrue(mockLTKListViewModelSubscriber.recievedError)
    }

    func testViewModelLoad_valid() {
        let mockStore = MockFoodListStore_Valid()
        let mockFoodListViewModelSubscriber = MockLTKListViewModelSubscriber()
        let viewModelStub = LTKListViewModel(store: mockStore)

        XCTAssertFalse(mockFoodListViewModelSubscriber.hasSubscriber)
        viewModelStub.ltkEntitySubject.subscribe(mockFoodListViewModelSubscriber)
        XCTAssertTrue(mockFoodListViewModelSubscriber.hasSubscriber)

        viewModelStub.loadData()
        XCTAssertTrue(mockFoodListViewModelSubscriber.recievedInput)
    }

    func testViewModelLoad_Search() {
        let mockStore = MockFoodListStore_Valid()
        let mockFoodListViewModelSubscriber = MockLTKListViewModelSubscriber()
        let viewModelStub = LTKListViewModel(store: mockStore)

        viewModelStub.ltkEntitySubject.subscribe(mockFoodListViewModelSubscriber)

        XCTAssertTrue(mockFoodListViewModelSubscriber.fetchedLTKs.isEmpty)
        viewModelStub.loadData()
        XCTAssertFalse(mockFoodListViewModelSubscriber.fetchedLTKs.isEmpty)

        XCTAssertEqual(mockFoodListViewModelSubscriber.fetchedLTKs.count, 10)
        viewModelStub.searchFoodList(for: "NO MATCH")
        XCTAssertEqual(mockFoodListViewModelSubscriber.fetchedLTKs.count, 0)

        viewModelStub.searchFoodList(for: "fAKE")
        XCTAssertEqual(mockFoodListViewModelSubscriber.fetchedLTKs.count, 10)

        viewModelStub.searchFoodList(for: "FAKE")
        XCTAssertEqual(mockFoodListViewModelSubscriber.fetchedLTKs.count, 10)

        viewModelStub.searchFoodList(for: nil)
        XCTAssertEqual(mockFoodListViewModelSubscriber.fetchedLTKs.count, 10)
    }
}

struct MockFoodListStore_Invalid: LTKListsAPI {
    var totalServerLTK: Int { return 0 }
    func readLTKLists() -> Future<Result<LTKBase, APIFailure>, Never> {
        return Future { promise in
            promise(.success(.failure(.URLError)))
        }
    }
}

struct MockFoodListStore_Valid: LTKListsAPI {

    var totalServerLTK: Int { return 0 }

    private let fakeLTKBase = buildFakeLTKBase()

    func readLTKLists() -> Future<Result<LTKBase, APIFailure>, Never> {
        return Future { promise in
            promise(.success(.success(fakeLTKBase)))
        }
    }
}

final class MockLTKListViewModelSubscriber: Subscriber {

    var hasSubscriber = false
    var recievedInput = false
    var recievedError = false
    var fetchedLTKs: [LTK] = []


    typealias Input = Result<[LTK], APIFailure>
    typealias Failure = Never

    /// Subscriber is willing recieve unlimited values upon subscription
    func receive(subscription: Subscription) {
        hasSubscriber = true
        subscription.request(.unlimited)
    }

    /// .none, indicating that the subscriber will not adjust its demand
    func receive(_ input: Result<[LTK], APIFailure>) -> Subscribers.Demand {

        switch input {
            case .success(let fetchedLTKs):
                self.fetchedLTKs = fetchedLTKs
                recievedInput = true

            case .failure:
                recievedError = true
        }

        return .none
    }

    /// Print the completion event
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion", completion)
    }
}

private func buildFakeLTKs() -> [LTK] {
    return (0..<10).map { index -> LTK in
        return LTK(id: "\(index)",
                   hash: UUID().uuidString,
                   status: "fake status",
                   caption: "Fake caption",
                   share_url: nil,
                   profile_id: nil,
                   hero_image: nil,
                   date_created: nil,
                   date_updated: nil,
                   hero_image_width: nil,
                   hero_image_height: nil,
                   video_media_id: nil,
                   date_scheduled: nil,
                   date_published: nil,
                   profile_user_id: nil,
                   product_ids: nil)
    }
}

private func buildFakeLTKBase() -> LTKBase {
    return LTKBase(meta: nil, ltks: buildFakeLTKs(), profiles: nil, products: nil, media_objects: nil)
}
