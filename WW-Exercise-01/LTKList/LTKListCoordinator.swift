//
//  LTKListCoordinator.swift
//

import UIKit

final class LTKListCoordinator: WorkFlowCoordinator {

    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?
    var apiManager: APIManager?
    var model: Any?

    lazy var primaryViewController: UIViewController = {
        guard let apiManager = apiManager else { return UIViewController() }
        let viewModel = LTKListViewModel(store: apiManager)
        viewModel.transitionDelegate = transitionDelegate
        let ltkListViewController = LTKListViewController(viewModel: viewModel)
        return ltkListViewController
    }()

    func start() {
        if navigationController?.viewControllers.isEmpty == false {
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(primaryViewController, animated: false)
    }
}
