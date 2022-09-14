//
//  BaseNavigationController.swift
//  Vuukle
//
//  Created by Garnik Ghazaryan on 12.05.22.
//

import UIKit

class BaseNavigationController: UINavigationController {

    var mainViewController: UIViewController? {
        viewControllers.first
    }

    private let viewControllerToPresentOn: UIViewController

    init(presentingViewController: UIViewController) {
        let viewController = UIViewController()
        self.viewControllerToPresentOn = presentingViewController
        super.init(rootViewController: viewController)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeNavigationTapped(_:)))
        modalPresentationStyle = .fullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight
        viewControllerToPresentOn.view.window?.layer.add(transition, forKey: kCATransition)

        viewControllerToPresentOn.present(self, animated: false)
    }

    func dismiss() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft

        viewControllers.first?.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }

    // MARK: - Actions
    @objc func closeNavigationTapped(_ sender: Any) {
        dismiss()
    }
}
