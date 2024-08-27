//
//  SearchBar.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class SearchBar: UIView {
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = TextConstants.search.rawValue
        searchBar.setImage(UIImage(systemName: SystemImages.magnifyingglass.rawValue), for: .search, state: .normal)
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        prepareView()
    }
    
    private func prepareView() {
        addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
}
