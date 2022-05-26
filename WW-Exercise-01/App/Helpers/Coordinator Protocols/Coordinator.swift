//
//  Coordinator.swift
//

import UIKit

protocol Coordinator: AnyObject {
    var model: Any? { get set }
    var navigationController: UINavigationController? { get set }
    var transitionDelegate: TransitionDelegate? { get set }
    func start()
}

extension Coordinator {
    
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
