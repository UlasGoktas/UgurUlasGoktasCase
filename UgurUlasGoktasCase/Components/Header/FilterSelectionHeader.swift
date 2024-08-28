//
//  FilterSelectionHeader.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class FilterSectionHeader: UITableViewHeaderFooterView {
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .extraLargeMediumPoint, weight: .regular)
        label.textColor = .primaryDarkGray.withAlphaComponent(0.7)
        
        return label
    }()

    let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareView() {
        contentView.backgroundColor = .white
        contentView.addSubview(viewContainer)
        viewContainer.addSubview(labelTitle)
        viewContainer.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: .regularPoint),
            labelTitle.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),

            searchBar.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: .mediumPoint),
            searchBar.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: .regularPoint),
            searchBar.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -.regularPoint),
            searchBar.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -.regularPoint)
        ])
    }

    func configure(title: String, searchBarDelegate: UISearchBarDelegate?, isSearchBarVisible: Bool) {
        labelTitle.text = title
        if isSearchBarVisible {
            viewContainer.addSubview(searchBar)
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: .mediumPoint),
                searchBar.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: .regularPoint),
                searchBar.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -.regularPoint),
                searchBar.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -.mediumPoint)
            ])
        } else {
            searchBar.removeFromSuperview()
            NSLayoutConstraint.activate([
                labelTitle.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -.mediumPoint)
            ])
        }
        
        guard let searchBarDelegate else { return }
        searchBar.setDelegate(searchBarDelegate)
    }
    
    func contains(searchBar: UISearchBar) -> Bool {
        self.searchBar.searchBar == searchBar
    }
}

