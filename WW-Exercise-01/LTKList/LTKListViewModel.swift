//

import Combine
import Foundation
import OrderedCollections

final class LTKListViewModel {

    let ltkEntitySubject = PassthroughSubject<[LTK], APIFailure>()
    weak var transitionDelegate: TransitionDelegate?

    private var ltksBase: [LTKBase] = []
    private var disposeBag = Set<AnyCancellable>()
    private let store: LTKListsAPI

    private var fetchedLTKS = OrderedSet([LTK]()) {
        didSet {
            ltkEntitySubject.send(self.fetchedLTKS.elements)
        }
    }

    init(store: LTKListsAPI) {
        self.store = store
    }

    func loadData() {

        let recievedLTK = { [unowned self] (newLTKBase: LTKBase) -> Void in
            ltksBase.append(newLTKBase)
            self.fetchedLTKS.append(contentsOf: newLTKBase.ltks ?? [])
        }
        
        let receivedLTKCompletion = { [unowned self] (completion: Subscribers.Completion<APIFailure>) -> Void in
            switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    ltkEntitySubject.send(completion: .failure(failure))
            }
            
        }

        store.readLTKLists()
            .sink(receiveCompletion: receivedLTKCompletion, receiveValue: recievedLTK)
            .store(in: &disposeBag)
    }

    func searchFoodList(for query: String?) {

        if let query = query, !query.isEmpty {
            let lowerCaseQuery = query.lowercased()
            let filteredLTKList = fetchedLTKS.elements.filter { $0.caption?.lowercased().contains(lowerCaseQuery) == true }
            ltkEntitySubject.send(filteredLTKList)
        } else {
            ltkEntitySubject.send(fetchedLTKS.elements)
        }
    }

    func didTapItem(model: LTK) {

        guard let profile = (ltksBase.compactMap { $0.profiles }.flatMap { $0 }.first { $0.id == model.profile_id }) else { return }
        let products = ltksBase.flatMap { base -> [Product] in
            guard let productIDs = model.product_ids, let products = base.products else { return [] }
            return products.filter { productIDs.contains($0.id ?? "") }
        }

        let payload = DetailViewModel(LTK: model, profile: profile, products: .init(products))
        transitionDelegate?.process(transition: .showDetailView, with: payload)
    }

    func prefetchData(for indexPaths: [IndexPath]) {

        guard let index = indexPaths.last?.row else { return }
        let fetchedLTKLastIndexBatch = fetchedLTKS.count - 10

        let indexIsWithinLoadedRange = 0..<fetchedLTKLastIndexBatch ~= index

        if index < store.totalServerLTK, !indexIsWithinLoadedRange {
            loadData()
        }
    }
}
