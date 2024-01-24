//
//  GifCollectionViewCell.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 27/12/2023.
//

import UIKit
import SDWebImage

class GifCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GifCollectionViewCell"
    
    private let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loadingIndicator = LoadingIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(gifImageView)
        contentView.addSubview(loadingIndicator)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifImageView.frame = contentView.bounds
        loadingIndicator.center = contentView.center
    }
    
    public func configure(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        loadingIndicator.isHidden = false 
        loadingIndicator.startAnimating()
        gifImageView.sd_setImage(with: url) { [weak self] (_, _, _, _) in
            self?.loadingIndicator.isHidden = true
        }
    }
}
