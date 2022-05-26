//
//  APIManager.swift


import Combine
import Foundation

protocol PokemonListStore {
    func readPokemonList(offset: Int) -> Future<AllPokemonBase, Failure>
}

protocol PokemonDetailStore {
    func readPokemonDetails(for pokemon: Pokemon) -> Future<PokemonDetailBase, Failure>
}

final class APIManager {
    
}

extension APIManager: PokemonDetailStore {
    
    func readPokemonDetails(for pokemon: Pokemon) -> Future<PokemonDetailBase, Failure> {
        
        return Future { promise in
            
            guard let url = URL(string: pokemon.url) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }

                do {

                    let decoder = JSONDecoder()
                    let pokemonDetailBase = try decoder.decode(PokemonDetailBase.self, from: data)
                    promise(.success(pokemonDetailBase))

                } catch {
                    promise(.failure(.APIError(error)))
                }

            }

            task.resume()
        }
    }
}

extension APIManager: PokemonListStore {
        
    func readPokemonList(offset: Int) -> Future<AllPokemonBase, Failure> {
        
        return Future { promise in
            
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=50&offset=\(offset)") else {
                promise(.failure(.urlConstructError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }

                do {

                    let decoder = JSONDecoder()
                    let allPokemonBase = try decoder.decode(AllPokemonBase.self, from: data)
                    promise(.success(allPokemonBase))

                } catch {
                    promise(.failure(.APIError(error)))
                }

            }

            task.resume()
        }
    }
}
