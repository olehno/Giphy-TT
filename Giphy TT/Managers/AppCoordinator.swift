//
//  AppCoordinator.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 04/01/2024.
//

import UIKit

final class AppCoordinator {
    
    static let shared = AppCoordinator()
    
    func start(window: UIWindow, scene: UIWindowScene) {
        window.windowScene = scene
        window.rootViewController = MainTabBarViewController()
        window.makeKeyAndVisible()
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    func searchViewControllerDidTapedItem(model: Gif) {
        let vc = DetailViewController()
        vc.configure(with: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteViewController: FavoriteViewControllerDelegate {
    func favoriteViewControllerDidTapedItem(model: Gif) {
        let vc = DetailViewController()
        vc.configure(with: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension NetworkMonitor: NetworkMonitorDelegate {
    func presentInternetConnectionFailure(isConnected: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.filter({ $0.isKeyWindow }).first,
              !self.isConnected else {
            return
        }
        let rootViewController = window.rootViewController
        if let presentedVC = rootViewController?.presentedViewController, presentedVC is InternetConnectionFailureViewController {
            return
        }
        let internetConnectionFailureVC = InternetConnectionFailureViewController()
        internetConnectionFailureVC.modalPresentationStyle = .fullScreen
        rootViewController?.present(internetConnectionFailureVC, animated: true)
    }
    
    
}
