//
//  ViewController.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 23/12/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidTapedItem(model: Gif)
}

class SearchViewController: UIViewController {
    // MARK: - Parameters
    public weak var delegate: SearchViewControllerDelegate?
    private var gifsRelay = BehaviorRelay(value: [Gif]())
    private let disposeBag = DisposeBag()
    private var offset = 0
    var timer: Timer?
    // MARK: - UI Elements
    private var searchResultsCollectionView: UICollectionView = {
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
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for a Gif"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Here will be displayed gifs!"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(searchResultsCollectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(messageLabel)
        searchResultsCollectionView.delegate = self
        collectionViewSetUp()
        didTapGifSetUp()
        setupConstraints()
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
        loadingIndicator.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50)
    }
    // MARK: - Private Func
    private func collectionViewSetUp() {
        gifsRelay.bind(to: searchResultsCollectionView.rx.items(cellIdentifier: GifCollectionViewCell.identifier, cellType: GifCollectionViewCell.self)) { (index, item, cell) in
            cell.configure(with: item.images.original.url ?? "")
            self.delegate = self
        }
        .disposed(by: disposeBag)
        // Display message
        gifsRelay
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
                self?.messageLabel.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    private func didTapGifSetUp() {
        searchResultsCollectionView.rx.modelSelected(Gif.self).subscribe(onNext: { [weak self] (selectedGif: Gif) in
            self?.delegate?.searchViewControllerDidTapedItem(model: selectedGif)
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

extension SearchViewController: UISearchResultsUpdating, UICollectionViewDelegate {
    // MARK: - Appearance Settings
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let layout = UICollectionViewFlowLayout()
        if size.width > size.height {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        } else {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: 200)
        }
        searchResultsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    // Is bottom of screen reached
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging called")
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            if let query = searchController.searchBar.text {
                loadMore(for: query)
            }
        }
    }
    // MARK: - Search Func
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        offset = 0
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.performSearch(with: query, and: self.offset)
        })
    }
    
    private func performSearch(with query: String, and offset: Int) {
        APICaller.shared.getGifs(with: query, offset: offset) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gifs):
                    self?.gifsRelay.accept(gifs)
                    self?.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadMore(for query: String) {
        loadingIndicator.startAnimating()
        offset += gifsRelay.value.count
        APICaller.shared.getGifs(with: query, offset: self.offset) { result in
            defer {
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                }
            }
            switch result {
            case .success(let gifs):
                self.gifsRelay.accept(self.gifsRelay.value + gifs)
                DispatchQueue.main.async {
                    self.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
