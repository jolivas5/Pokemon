//
//  PokemonDetailViewModel.swift

import Combine
import Foundation
import OrderedCollections

final class PokemonDetailViewModel {
    
    let pokemon: Pokemon
    let store: PokemonDetailStore
    let pokemonDetailSubject = CurrentValueSubject<PokemonDetailBase?, Failure>(nil)
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(pokemon: Pokemon, store: PokemonDetailStore = APIManager()) {
        self.pokemon = pokemon
        self.store = store
    }
    
    func loadData() {

        let recievedPokemons = { [unowned self] (fetchedPokemonDetails: PokemonDetailBase) -> Void in
            pokemonDetailSubject.send(fetchedPokemonDetails)
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    pokemonDetailSubject.send(completion: .failure(failure))
            }
        }

        store.readPokemonDetails(for: pokemon)
            .sink(receiveCompletion: completion, receiveValue: recievedPokemons)
            .store(in: &disposeBag)
    }
}
