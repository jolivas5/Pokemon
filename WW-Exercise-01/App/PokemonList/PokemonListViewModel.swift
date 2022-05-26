//

import Combine
import Foundation
import OrderedCollections

final class PokemonListViewModel {

    let pokemonListSubject = PassthroughSubject<[Pokemon], Failure>()
    weak var transitionDelegate: TransitionDelegate?

    private var ltksBase: [Pokemon] = []
    private var disposeBag = Set<AnyCancellable>()
    private let store: PokemonListStore

    private var fetchedBase: AllPokemonBase?
    
    private var fetchedPokemon = OrderedSet([Pokemon]()) {
        didSet {
            pokemonListSubject.send(fetchedPokemon.elements)
        }
    }

    init(store: PokemonListStore = APIManager()) {
        self.store = store
    }

    func loadData(offset: Int = 0) {

        let recievedPokemons = { [unowned self] (newPokemonBase: AllPokemonBase) -> Void in
            fetchedBase = newPokemonBase
            fetchedPokemon.append(contentsOf: newPokemonBase.results)
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    pokemonListSubject.send(completion: .failure(failure))
            }
        }

        store.readPokemonList(offset: offset)
            .sink(receiveCompletion: completion, receiveValue: recievedPokemons)
            .store(in: &disposeBag)
    }

    func searchPokemon(with query: String?) {

        if let query = query, !query.isEmpty {
            let lowerCaseQuery = query.lowercased()
            let filteredPokemonList = fetchedPokemon.elements.filter { $0.name.lowercased().contains(lowerCaseQuery) }
            pokemonListSubject.send(filteredPokemonList)
        } else {
            pokemonListSubject.send(fetchedPokemon.elements)
        }
    }
    
    func didTapItem(model: Pokemon) {
        transitionDelegate?.process(transition: .showPokemonDetail, with: model)
    }

    func prefetchData(for indexPaths: [IndexPath]) {

        guard let index = indexPaths.last?.row else { return }
        
        let pokemonAlreadyLoaded = fetchedPokemon.count
        if index > pokemonAlreadyLoaded - 10 {
            loadData(offset: pokemonAlreadyLoaded)
        }
    }
}
