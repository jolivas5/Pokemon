//
//  Coordinator.swift
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol UICoordinator: Coordinator {
    var model: Any? { get set }
    var primaryViewController: UIViewController { get }
    var navigationController: UINavigationController? { get set }
    var transitionDelegate: TransitionDelegate? { get set }
}

extension UICoordinator {
    func inject(model: Any?) {
        self.model = model
    }

    func inject(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func inject(transitionDelegate: TransitionDelegate) {
        self.transitionDelegate = transitionDelegate
    }
}

protocol APICoordinator: Coordinator {
    var apiManager: APIManager? { get set }
}

protocol WorkFlowCoordinator: UICoordinator, APICoordinator { }

extension APICoordinator {
    func inject(apiManager: APIManager) {
        self.apiManager = apiManager
    }
}
