//
//  LoadingIndicator.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 21/01/2024.
//

import UIKit

class LoadingIndicator: UIView {
    
    private let loadingIndicator = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        loadingIndicator.path = circularPath.cgPath
        loadingIndicator.fillColor = UIColor.clear.cgColor
        loadingIndicator.strokeColor = UIColor.systemRed.cgColor
        loadingIndicator.lineWidth = 10
        loadingIndicator.strokeEnd = 0.25
        loadingIndicator.lineCap = .round
        self.layer.addSublayer(loadingIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimating() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (completed) in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) {(completed) in
                self.startAnimating()
            }
        }
    }
}
