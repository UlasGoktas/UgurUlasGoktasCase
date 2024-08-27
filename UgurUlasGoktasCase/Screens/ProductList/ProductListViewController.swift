//
//  ProductListViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class ProductListViewController: BaseViewController<ProductListViewModel> {
    // MARK: Constants
    private let collectionViewHeight: CGFloat = 250
    private let selectFilterButtonWidth: CGFloat = 150
    
    // MARK: UI Elements
    private lazy var searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    private lazy var viewFilter: UIView = {
        let filterView = UIView()
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        return filterView
    }()
    
    private lazy var labelFilter: UILabel = {
        let filterLabel = UILabel()
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.text = TextConstants.filters.rawValue
        filterLabel.font = UIFont.systemFont(ofSize: .largePoint)
        
        return filterLabel
    }()
    
    private lazy var buttonFilter: UIButton = {
        let filterButton = UIButton()
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle(TextConstants.selectFilter.rawValue, for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = UIColor(hex: "#D9D9D9")
        filterButton.addTarget(self, action: #selector(filterButtonOnTap), for: .touchUpInside)
        
        return filterButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.itemSize = CGSize(width: (view.frame.width - .doubleLargePoint) / .extraSmallPoint, height: collectionViewHeight)
        layout.sectionInset = UIEdgeInsets(top: .regularPoint, left: .regularPoint, bottom: .regularPoint, right: .regularPoint)
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.productCollectionViewCell.rawValue)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSearchBar()
        prepareFilterView()
        prepareCollectionView()
        fetchProductList()
    }
    
    private func prepareSearchBar() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .regularPoint),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            searchBar.heightAnchor.constraint(equalToConstant: .doubleLargePoint)
        ])
        
        searchBar.setDelegate(self)
    }
    
    private func prepareFilterView() {
        view.addSubview(viewFilter)
        
        viewFilter.addSubview(labelFilter)
        viewFilter.addSubview(buttonFilter)
        
        NSLayoutConstraint.activate([
            viewFilter.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: .regularPoint),
            viewFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            viewFilter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            viewFilter.heightAnchor.constraint(equalToConstant: .doubleLargePoint),
            
            labelFilter.leadingAnchor.constraint(equalTo: viewFilter.leadingAnchor),
            labelFilter.centerYAnchor.constraint(equalTo: viewFilter.centerYAnchor),
            
            buttonFilter.trailingAnchor.constraint(equalTo: viewFilter.trailingAnchor),
            buttonFilter.topAnchor.constraint(equalTo: viewFilter.topAnchor),
            buttonFilter.bottomAnchor.constraint(equalTo: viewFilter.bottomAnchor),
            buttonFilter.widthAnchor.constraint(equalToConstant: selectFilterButtonWidth),
        ])
    }
    
    private func prepareCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: viewFilter.bottomAnchor, constant: .regularPoint),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchProductList() {
        viewModel.fetchProductList { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func filterButtonOnTap() {
        let filterOptions = viewModel.getFilterOptions()
        let filterViewController = FilterViewController(filterOptions: filterOptions, sortSelections: viewModel.sortSelections)
        filterViewController.delegate = self
        filterViewController.modalPresentationStyle = .automatic
        
        present(filterViewController, animated: true, completion: nil)
    }
}

// MARK: UICollectionView extension
extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.productCollectionViewCell.rawValue, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let product = viewModel.product(at: indexPath.row) else { return cell }
        cell.configure(with: product, isFavorite: viewModel.isFavorite(product: product))
        
        cell.addToCartButtonTapped = { [weak self] product in
            guard let product else { return }
            
            self?.viewModel.addToCart(product: product)
        }
        
        cell.addToFavoriteButtonTapped = { [weak self] product in
            guard let product else { return }
            
            self?.viewModel.toggleFavorite(product: product)
            self?.collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let product = viewModel.product(at: indexPath.row)
//        let productDetailViewController = ProductDetailViewController(product: product)
//
//        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterProducts(by: searchText) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension ProductListViewController: FilterViewControllerDelegate {
    func applyFilters(selectedFilters: [String : [String]], sortSelection: String?) {
        viewModel.applyFilters(selectedFilters: selectedFilters, sortSelection: sortSelection) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
