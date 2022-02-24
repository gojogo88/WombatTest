//
//  AppCoordinator.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = ViewController()
        let viewModel = AccountViewModel(networkService: NetworkService.shared)
        viewController.viewModel = viewModel
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
    }
}
