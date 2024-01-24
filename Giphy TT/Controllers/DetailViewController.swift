//
//  DetailViewController.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 28/12/2023.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    // MARK: - Properties
    private var savedGifs: [Gif] = [Gif]()
    private var gif: Gif?
    private var isGifExistInArray: Bool {
        get {
            return savedGifs.contains { $0.id == self.gif?.id }
        }
        set {}
    }
    // MARK: - ScrollView & Container
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    // MARK: - UI Elements
    private let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ID"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    public let publishDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Publication Date"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var addToFavoriteButton: UIButton = {
        let button = UIButton()
        button.setTitle(isGifExistInArray ? "Delete from favorite" : "Add to favorite", for: .normal)
        button.backgroundColor = isGifExistInArray ? .systemRed : .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(addToFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)  // You can choose a different blur style here
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    private let errorView = ErrorMessageView()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(gifImageView)
        scrollStackViewContainer.addArrangedSubview(idLabel)
        scrollStackViewContainer.addArrangedSubview(titleLabel)
        scrollStackViewContainer.addArrangedSubview(publishDateLabel)
        scrollStackViewContainer.addArrangedSubview(spacerView)
        scrollStackViewContainer.addArrangedSubview(addToFavoriteButton)
        applyConstraints()
        if let data = UserDefaults.standard.object(forKey: "savedGifs!") as? Data,
           let decodedGifs = try? JSONDecoder().decode([Gif].self, from: data) {
            savedGifs = decodedGifs
        } else {
            showErrorView()
        }
    }
    // MARK: - Public Func
    public func configure(with model: Gif) {
        guard let gifUrl = URL(string: model.images.original.url ?? "") else { return }
        gifImageView.sd_setImage(with: gifUrl)
        idLabel.text = "Gif ID - \(model.id)"
        titleLabel.text = "Title - \(model.title ?? "Unknown")"
        publishDateLabel.text = "Publication Date - \(model.import_datetime ?? "Unknown")"
        self.gif = model
    }
    // MARK: - Private Func
    @objc private func addToFavoriteButtonTapped() {
        if isGifExistInArray {
            if let index = savedGifs.firstIndex(where: { $0.id == gif?.id }) {
                savedGifs.remove(at: index)
            }
            if let encodedData = try? JSONEncoder().encode(savedGifs) {
                UserDefaults.standard.set(encodedData, forKey: "savedGifs")
            }
            NotificationCenter.default.post(name: Notification.Name("SavedGifsUpdated"), object: nil)
            updateUI(isGifExistInArray: isGifExistInArray)
            isGifExistInArray.toggle()
        } else {
            savedGifs.append(gif!)
            if let encoded = try? JSONEncoder().encode(savedGifs) {
                UserDefaults.standard.set(encoded, forKey: "savedGifs")
            }
            NotificationCenter.default.post(name: Notification.Name("SavedGifsUpdated"), object: nil)
            updateUI(isGifExistInArray: isGifExistInArray)
            isGifExistInArray.toggle()
        }
    }
    
    private func updateUI(isGifExistInArray: Bool) {
        addToFavoriteButton.setTitle(isGifExistInArray ? "Delete from favorite" : "Add to favorite", for: .normal)
        addToFavoriteButton.backgroundColor = isGifExistInArray ? .systemRed : .systemGreen
    }
    
    
    
    private func showErrorView() {
        errorView.messegeTextLabel.text = "Failed to get local data!"
        errorView.center = view.center
        blurEffectView.frame = self.view.bounds
        view.addSubview(blurEffectView)
        view.addSubview(errorView)
    }
    
    private func applyConstraints() {
        let scrollViewConstraits = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        let scrollStackViewContainerConstraints = [
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]
        NSLayoutConstraint.activate(scrollViewConstraits)
        NSLayoutConstraint.activate(scrollStackViewContainerConstraints)
    }
}
