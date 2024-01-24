//
//  ErrorMessageView.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 22/01/2024.
//

import UIKit

class ErrorMessageView: UIView {
    
    
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
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 250, height: 195)
        backgroundColor = UIColor.systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
