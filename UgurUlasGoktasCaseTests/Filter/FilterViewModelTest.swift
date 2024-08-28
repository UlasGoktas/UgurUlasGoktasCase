//
//  FilterViewModelTest.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 29.08.2024.
//

import XCTest
@testable import UgurUlasGoktasCase

final class FilterViewModelTests: XCTestCase {
    var viewModel: FilterViewModel!
    
    override func setUp() {
        super.setUp()
        let filterSelections = [
            ["Brand": ["BrandA", "BrandB"]],
            ["Model": ["ModelX", "ModelY"]]
        ]
        let sortSelections = ["Price Low to High", "Price High to Low"]
        let selectedFilters: [String: [String]] = [:]
        let selectedSort: String? = nil
        
        viewModel = FilterViewModel(
            filterSelections: filterSelections,
            sortSelections: sortSelections,
            selectedFilters: selectedFilters,
            selectedSort: selectedSort
        )
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testNumberOfRows_InSortSection_ReturnsCorrectCount() {
        // Given
        let section = 0
        
        // When
        let numberOfRows = viewModel.numberOfRows(in: section)
        
        // Then
        XCTAssertEqual(numberOfRows, viewModel.sortSelections.count)
    }
    
    func testNumberOfRows_InFilterSection_ReturnsCorrectCount() {
        // Given
        let section = 1
        
        // When
        let numberOfRows = viewModel.numberOfRows(in: section)
        
        // Then
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testSelection_InSortSection_ReturnsCorrectValue() {
        // Given
        let indexPath = IndexPath(row: 1, section: 0)
        
        // When
        let selection = viewModel.selection(at: indexPath)
        
        // Then
        XCTAssertEqual(selection, "Price High to Low")
    }
    
    func testSelection_InFilterSection_ReturnsCorrectValue() {
        // Given
        let indexPath = IndexPath(row: 1, section: 1)
        
        // When
        let selection = viewModel.selection(at: indexPath)
        
        // Then
        XCTAssertEqual(selection, "BrandB")
    }
    
    func testIsSelected_InSortSection_ReturnsTrueIfSelected() {
        // Given
        viewModel.selectedSort = "Price Low to High"
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let isSelected = viewModel.isSelected(at: indexPath)
        
        // Then
        XCTAssertTrue(isSelected)
    }
    
    func testIsSelected_InFilterSection_ReturnsTrueIfSelected() {
        // Given
        viewModel.selectedFilter = ["Brand": ["BrandA"]]
        let indexPath = IndexPath(row: 0, section: 1)
        
        // When
        let isSelected = viewModel.isSelected(at: indexPath)
        
        // Then
        XCTAssertTrue(isSelected)
    }
    
    func testSelectOption_TogglesSortSelection() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        viewModel.selectOption(at: indexPath)
        
        // Then
        XCTAssertEqual(viewModel.selectedSort, "Price Low to High")
    }
    
    func testSelectOption_TogglesFilterSelection() {
        // Given
        let indexPath = IndexPath(row: 0, section: 1)
        
        // When
        viewModel.selectOption(at: indexPath)
        
        // Then
        XCTAssertEqual(viewModel.selectedFilter["Brand"], ["BrandA"])
        
        // When
        viewModel.selectOption(at: indexPath)
        
        // Then
        XCTAssertNil(viewModel.selectedFilter["Brand"])
    }
    
    func testSearchFilter_UpdatesSearchResults() {
        // Given
        let searchText = "BrandA"
        let section = 1
        
        // When
        viewModel.searchFilter(for: searchText, in: section)
        
        // Then
        XCTAssertEqual(viewModel.searchResults[0]["Brand"], ["BrandA"])
    }
    
    func testSearchFilter_EmptyTextReturnsAllResults() {
        // Given
        let searchText = ""
        let section = 1
        
        // When
        viewModel.searchFilter(for: searchText, in: section)
        
        // Then
        XCTAssertEqual(viewModel.searchResults, viewModel.filterSelections)
    }
}
