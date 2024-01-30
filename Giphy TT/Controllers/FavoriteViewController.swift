//
//  FavoriteViewController.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 29/12/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol FavoriteViewControllerDelegate: AnyObject {
    func favoriteViewControllerDidTapedItem(model: Gif)
}

class FavoriteViewController: UIViewController {
    // MARK: - Properties
    private var savedGifsRelay = BehaviorRelay(value: [Gif]())
    public weak var delegate: FavoriteViewControllerDelegate?
    private let disposeBag = DisposeBag()
    // MARK: - UIElements
    public var savedGifsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Сheck screen rotation
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        } else {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: 200)
        }
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Here will be displayed saved gifs!"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGifsSaves()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SavedGifsUpdated"), object: nil, queue: nil) { _ in
            self.fetchGifsSaves()
        }
        collectionViewSetUp()
        didTapGifSetUp()
        view.backgroundColor = .systemBackground
        title = "Favorite Gifs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(savedGifsCollectionView)
        view.addSubview(messageLabel)
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        savedGifsCollectionView.frame = view.bounds
    }
    // MARK: - Private Func
    private func fetchGifsSaves() {
        if let data = UserDefaults.standard.object(forKey: "savedGifs") as? Data,
           let decodedGifs = try? JSONDecoder().decode([Gif].self, from: data) {
            savedGifsRelay.accept(decodedGifs)
        } else {
            showError()
        }
    }
    
    private func collectionViewSetUp() {
        savedGifsRelay.bind(to: savedGifsCollectionView.rx.items(cellIdentifier: GifCollectionViewCell.identifier, cellType: GifCollectionViewCell.self)) { (index, item, cell) in
            cell.configure(with: item.images.original.url ?? "")
            self.delegate = self
        }
        .disposed(by: disposeBag)
        // Display message
        savedGifsRelay
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
                self?.messageLabel.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    private func showError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ooops...", message: "Failed to get local data!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func didTapGifSetUp() {
        savedGifsCollectionView.rx.modelSelected(Gif.self).subscribe(onNext: { [weak self] selectedGif in
            self?.delegate?.favoriteViewControllerDidTapedItem(model: selectedGif)
        }).disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        let messageLabelConstraint = [
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(messageLabelConstraint)
    }
}

extension FavoriteViewController {
    // MARK: - Appearance Settings
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let layout = UICollectionViewFlowLayout()
        if size.width > size.height {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        } else {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: 200)
        }
        savedGifsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

