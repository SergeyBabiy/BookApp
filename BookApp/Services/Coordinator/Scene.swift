//
//  Scene.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift

enum Scene {
    case none
    case lauchScreen(LaunchUpdateViewModel)
    case home(HomeViewModel)
    case debug(DebugViewModel)
    case galaxionAlert(CustomAlertViewModel)
    case testView(TestViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .none:
            return UIViewController()
        case .galaxionAlert(let viewModel):
            return CustomAlertViewController(viewModel: viewModel)
        case .debug(let viewModel):
            return UINavigationController(rootViewController: DebugViewController(viewModel: viewModel))
        case .lauchScreen(let viewModel):
            return LaunchScreenViewController(viewModel: viewModel)
        case .home(let viewModel):
            return UINavigationController(rootViewController: HomeViewController(viewModel: viewModel))
        case .testView(let viewModel):
            return TestViewController(viewModel: viewModel)
        }
    }
}
