//
//  DetailViewCoordinator.swift

import UIKit

final class DetailViewCoordinator: WorkFlowCoordinator {

    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?
    var apiManager: APIManager?
    var model: Any?

    private var detailViewModel: DetailViewModel {
        return model as! DetailViewModel
    }

    var primaryViewController: UIViewController {
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        return detailViewController
    }

    func start() {
        navigationController?.pushViewController(primaryViewController, animated: true)
    }
}
