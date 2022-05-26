//
//  Transition.swift


import Combine

protocol TransitionDelegate: AnyObject {
    func process(transition: Transition, with model: Any?)
}

enum Transition {
    case showMainScreen
    case showPokemonDetail
}
