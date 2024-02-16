//
//  MainViewController.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 29/12/2023.
//

import UIKit
import RxSwift

class MainTabBarViewController: UITabBarController {
    
    private let errorView = OfflineView()
    private let disposeBag = DisposeBag()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: SearchViewController())
        let vc2 = UINavigationController(rootViewController: FavoriteViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        
        vc1.title = "Search"
        vc2.title = "Favorite"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
        configureNetworkHandling()
    }
    
    private func configureNetworkHandling() {
        view.addSubview(blurEffectView)
        view.addSubview(errorView)
        errorView.center = view.center
        errorView.isHidden = false
        blurEffectView.isHidden = false
        blurEffectView.frame = self.view.bounds
        NetworkMonitor.shared.isConnectedRelay.subscribe { isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    self.view.isUserInteractionEnabled = true
                    self.errorView.isHidden = true
                    self.blurEffectView.isHidden = true
                } else {
                    self.view.isUserInteractionEnabled = false
                    self.errorView.isHidden = false
                    self.blurEffectView.isHidden = false
                }
            }
        }.disposed(by: disposeBag)
    }
}
