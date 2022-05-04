//
//  AppCoordinator.swift
//

import UIKit

final class AppCoordinator: Coordinator {

    let navigationViewController = UINavigationController()

    private let apiManager = APIManager()

    func start() {
        process(transition: .showLTKList, with: nil)
    }

    private var coordinatorRegister: [Transition: WorkFlowCoordinator] = [.showLTKList: LTKListCoordinator(),
                                                                          .showDetailView: DetailViewCoordinator()]
}

extension AppCoordinator: TransitionDelegate {

    func process(transition: Transition, with model: Any?) {
        print("Processing route: \(transition)")

        let coordinator = coordinatorRegister[transition]
        coordinator?.inject(model: model)
        coordinator?.inject(apiManager: apiManager)
        coordinator?.inject(transitionDelegate: self)
        coordinator?.inject(navigationController: navigationViewController)
        coordinator?.start()
    }
}
