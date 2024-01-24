//
//  OfflineView.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 22/01/2024.
//

import UIKit

class OfflineView: UIView {
    
    
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
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Ooops..."
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    public var messegeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "No internet connection!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 250, height: 195)
        backgroundColor = UIColor.systemGray
        addSubview(statusUIImageView)
        addSubview(opsMessageLabel)
        addSubview(messegeTextLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let imageConstraints = [
            statusUIImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusUIImageView.bottomAnchor.constraint(equalTo: opsMessageLabel.topAnchor, constant: -8),
            statusUIImageView.widthAnchor.constraint(equalToConstant: 85),
            statusUIImageView.heightAnchor.constraint(equalToConstant: 85)
        ]
        let opsLabelConstraints = [
            opsMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            opsMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 25)
        ]
        let messageConstraints = [
            messegeTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messegeTextLabel.topAnchor.constraint(equalTo: opsMessageLabel.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(opsLabelConstraints)
        NSLayoutConstraint.activate(messageConstraints)
    }
    
}
