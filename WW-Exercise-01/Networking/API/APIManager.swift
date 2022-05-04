//
//  APIManager.swift


import Combine
import Foundation

final class APIManager {
    private let endpointBuilder = LTKEndpointBuilder()
}

protocol LTKListsAPI {
    var totalServerLTK: Int { get }
    func readLTKLists() -> Future<LTKBase, APIFailure>
}

extension APIManager: LTKListsAPI {
    var totalServerLTK: Int {
        return endpointBuilder.totalServerLTKs
    }

    func readLTKLists() -> Future<LTKBase, APIFailure> {
        return endpointBuilder
            .isFeatured(true)
            .pageSize(20)
            .fetch()
    }
}
