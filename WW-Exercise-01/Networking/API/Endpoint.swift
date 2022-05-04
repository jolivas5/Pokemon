//
//  Endpoint.swift
//

import Combine
import Foundation

final class LTKEndpointBuilder {

    var totalServerLTKs: Int {
        return meta?.total_results ?? 0
    }

    private var meta: Meta?
    private var featured = true
    private var pageSize = 20

    @discardableResult func isFeatured(_ featured: Bool) -> LTKEndpointBuilder {
        self.featured = featured
        return self
    }

    @discardableResult func pageSize(_ pageSize: Int) -> LTKEndpointBuilder {
        self.pageSize = pageSize
        return self
    }

    func fetch() -> Future<LTKBase, APIFailure> {

        return Future { [weak self] promise in

            let url = self?.meta == nil ? self?.baseURL : URL(string: self?.meta?.next_url ?? "")
            guard let self = self, let url = url else { promise(.failure(.URLError)); return }

            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                guard let data = data, case .none = error else { promise(.failure(.URLError)); return }

                do {

                    let decoder = JSONDecoder()
                    let LTKBaseModel = try decoder.decode(LTKBase.self, from: data)
                    self.meta = LTKBaseModel.meta
                    promise(.success(LTKBaseModel))

                } catch {
                    promise(.failure(.captured(error)))
                }

            }

            task.resume()
        }
    }

    private var baseURL: URL? {
        let LTKBaseEndpoint = "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks"
        return URL(string: LTKBaseEndpoint + "/?featured=\(featured)&limit=\(pageSize)")
    }
}

// LTKEndpointBuilder().isFeatured(true).pageSize(20).fetch()
