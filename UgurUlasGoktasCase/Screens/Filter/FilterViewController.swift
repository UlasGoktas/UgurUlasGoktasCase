//
//  FilterViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func applyFilters(selectedFilters: [String: [String]], sortSelection: String?)
}

final class FilterViewController: UIViewController {
    private var viewModel: FilterViewModel
    weak var delegate: FilterViewControllerDelegate?
    
    private let headerViewHeight: CGFloat = 44
    private let applyButtonHeight: CGFloat = 44
    
    init(filterSelections: [[String: [String]]], sortSelections: [String], selectedFilters: [String: [String]], selectedSort: String?) {
        self.viewModel = FilterViewModel(filterSelections: filterSelections, sortSelections: sortSelections, selectedFilters: selectedFilters, selectedSort: selectedSort)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableViewSort: UITableView = {
        let tableView = createTableView()
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    private lazy var viewSeparator: UIView = {
        return createSeparatorView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .onePoint
        stackView.backgroundColor = .white.withAlphaComponent(0.5)
        
        return stackView
    }()
    
    private lazy var buttonApply: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(TextConstants.filterScreenApplyButtonText.rawValue, for: .normal)
        button.backgroundColor = .primaryBlue
        button.layer.cornerRadius = .smallPoint
        button.addTarget(self, action: #selector(applyButtonOnTap), for: .touchUpInside)
        
        return button
    }()
    
    private var dynamicTableViews: [UITableView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareDynamicTableViews()
    }
    
    private func prepareView() {
        view.backgroundColor = .white
        
        let headerView = createHeaderView()
        view.addSubview(headerView)
        view.addSubview(tableViewSort)
        view.addSubview(viewSeparator)
        view.addSubview(stackView)
        view.addSubview(buttonApply)
        
        prepareConstraints(headerView: headerView)
    }
    
    private func prepareDynamicTableViews() {
        for _ in viewModel.filterSelections {
            _ = createSeparatorView()
            let tableView = createTableView()
            dynamicTableViews.append(tableView)
            stackView.addArrangedSubview(tableView)
        }
    }
    
    private func createHeaderView() -> UIView {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: SystemImages.xmark.rawValue), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonOnTap), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = TextConstants.filter.rawValue
        titleLabel.font = UIFont.systemFont(ofSize: .regularPoint, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .regularPoint),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.5)
        
        return view
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.backgroundColor = .white
        tableView.register(FilterSelectionTableViewCell.self, forCellReuseIdentifier: FilterSelectionTableViewCell.reuseIdentifier)
        tableView.register(SortTableViewCell.self, forCellReuseIdentifier: SortTableViewCell.reuseIdentifier)
        tableView.register(FilterSectionHeader.self, forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.filterSectionHeader.rawValue)
        
        return tableView
    }
    
    private func prepareConstraints(headerView: UIView) {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            
            tableViewSort.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: .regularPoint),
            tableViewSort.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largePoint),
            tableViewSort.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .largePoint),
            tableViewSort.heightAnchor.constraint(equalToConstant: .doubleRegularPoint * CGFloat(viewModel.sortSelections.count + 1)),
            
            viewSeparator.topAnchor.constraint(equalTo: tableViewSort.bottomAnchor, constant: .regularPoint),
            viewSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            viewSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            viewSeparator.heightAnchor.constraint(equalToConstant: .onePoint),
            
            stackView.topAnchor.constraint(equalTo: viewSeparator.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            
            buttonApply.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .regularPoint),
            buttonApply.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            buttonApply.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            buttonApply.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.regularPoint),
            buttonApply.heightAnchor.constraint(equalToConstant: applyButtonHeight)
        ])
    }
    
    @objc private func closeButtonOnTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func applyButtonOnTap() {
        let userInfo: [String: Any] = [
            "selectedFilters": viewModel.selectedFilter,
            "selectedSort": viewModel.selectedSort as Any
        ]
        
        delegate?.applyFilters(selectedFilters: viewModel.selectedFilter, sortSelection: viewModel.selectedSort)
        NotificationCenter.default.post(name: .filtersApplied, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableView extension
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .doubleRegularPoint
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewSort {
            return viewModel.numberOfRows(in: 0)
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            return viewModel.numberOfRows(in: index + 1)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewSort {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.reuseIdentifier, for: indexPath) as? SortTableViewCell else {
                return UITableViewCell()
            }
            let selection = viewModel.selection(at: indexPath)
            let isSelected = viewModel.isSelected(at: indexPath)
            cell.configure(with: selection, isSelected: isSelected)
            
            return cell
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterSelectionTableViewCell.reuseIdentifier, for: indexPath) as? FilterSelectionTableViewCell else {
                return UITableViewCell()
            }
            let adjustedIndexPath = IndexPath(row: indexPath.row, section: index + 1)
            let selection = viewModel.selection(at: adjustedIndexPath)
            let isSelected = viewModel.isSelected(at: adjustedIndexPath)
            cell.configure(with: selection, isSelected: isSelected)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewSort {
            viewModel.selectOption(at: indexPath)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            let adjustedIndexPath = IndexPath(row: indexPath.row, section: index + 1)
            viewModel.selectOption(at: adjustedIndexPath)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        
        guard let searchBar = (tableView.headerView(forSection: .zero) as? FilterSectionHeader)?.searchBar.searchBar else { return }
        self.searchBar(searchBar, textDidChange: "")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifiers.filterSectionHeader.rawValue) as? FilterSectionHeader else {
            return nil
        }
        let title: String
        let isSearchBarVisible: Bool
        if tableView == tableViewSort {
            title = TextConstants.filterScreenHeaderText.rawValue
            isSearchBarVisible = false
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            title = viewModel.filterSelections[index].keys.first ?? ""
            isSearchBarVisible = true
        } else {
            return nil
        }
        headerView.configure(title: title, searchBarDelegate: self, isSearchBarVisible: isSearchBarVisible)
        return headerView
    }
}

// MARK: UISearchBar extension
extension FilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for (index, tableView) in dynamicTableViews.enumerated() {
            if let headerView = tableView.headerView(forSection: 0) as? FilterSectionHeader,
               headerView.contains(searchBar: searchBar) {
                viewModel.searchFilter(for: searchText, in: index + 1)
                tableView.reloadData()
                break
            }
        }
    }
}
