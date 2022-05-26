//
//  AppRouter.swift
//

import UIKit

final class AppRouter {

    let navigationViewController = UINavigationController()

    func start() {
        process(transition: .showMainScreen, with: nil)
    }

    private var coordinatorRegister: [Transition: Coordinator] = [.showMainScreen: PokemonListCoordinator(),
                                                                  .showPokemonDetail: PokemonDetailCoordinator()]
}

extension AppRouter: TransitionDelegate {

    func process(transition: Transition, with model: Any?) {
        print("Processing route: \(transition)")

        let coordinator = coordinatorRegister[transition]
        coordinator?.inject(transitionDelegate: self)
        coordinator?.inject(navigationController: navigationViewController)
        coordinator?.inject(model: model)
        coordinator?.start()
    }
}
