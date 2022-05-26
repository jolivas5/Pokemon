//
//  PokemonListCoordinator.swift
//

import UIKit

final class PokemonListCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?

    lazy var primaryViewController: UIViewController = {
        let viewModel = PokemonListViewModel()
        viewModel.transitionDelegate = transitionDelegate
        let ltkListViewController = PokemonListViewController(viewModel: viewModel)
        return ltkListViewController
    }()

    func start() {
        if navigationController?.viewControllers.isEmpty == false {
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(primaryViewController, animated: false)
    }
}
