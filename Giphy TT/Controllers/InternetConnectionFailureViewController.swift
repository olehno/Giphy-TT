//
//  InternetConnectionFailureUIView.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 23/12/2023.
//

import UIKit
import RxSwift

class InternetConnectionFailureViewController: UIViewController {
    //MARK: - Parameters
    private let networkMonitor = NetworkMonitor.shared
    private let disposeBag = DisposeBag()
    // MARK: - UI Elements
    private let statusUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "netErrorImg")
        return imageView
    }()
    
    private let opsMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Ooops..."
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "No Internet Connection"
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(statusUIImageView)
        view.addSubview(opsMessageLabel)
        view.addSubview(messageLabel)
        view.addSubview(continueButton)
        applyConstraints()
        
        networkMonitor.isConnectedRelay.subscribe { [weak self] isConnected in
            self?.updateViewAppearance(isConnected: isConnected)
            
        }
        .disposed(by: disposeBag)
    }
    // MARK: - Constraints
    private func applyConstraints() {
        let statusUIImageViewConstraints = [
            statusUIImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusUIImageView.bottomAnchor.constraint(equalTo: opsMessageLabel.topAnchor, constant: -20),
            statusUIImageView.widthAnchor.constraint(equalToConstant: 150),
            statusUIImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        let opsMessageLabelConstraints = [
            opsMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            opsMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        let messageLabelConstraints = [
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: opsMessageLabel.bottomAnchor, constant: 20)
        ]
        let continueButtonConstraints = [
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(statusUIImageViewConstraints)
        NSLayoutConstraint.activate(opsMessageLabelConstraints)
        NSLayoutConstraint.activate(messageLabelConstraints)
        NSLayoutConstraint.activate(continueButtonConstraints)
    }
}
// MARK: - Private Functions
extension InternetConnectionFailureViewController {
    private func updateViewAppearance(isConnected: Bool) {
        if isConnected {
            DispatchQueue.main.async {
                self.continueButton.isEnabled = true
                self.continueButton.backgroundColor = .systemBlue
                self.statusUIImageView.image = UIImage(named: "okImg")
                self.opsMessageLabel.text = "Connected!"
                self.messageLabel.text = "You can continue using the app"
            }
        } else {
            DispatchQueue.main.async {
                self.continueButton.isEnabled = false
                self.continueButton.backgroundColor = .gray
                self.statusUIImageView.image = UIImage(named: "netErrorImg")
                self.opsMessageLabel.text = "Ooops..."
                self.messageLabel.text = "No Internet Connection"
            }
        }
    }
    
    @objc private func continueButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
