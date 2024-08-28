//
//  FavoriteListViewModelTest.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 29.08.2024.
//

import XCTest
@testable import UgurUlasGoktasCase

final class FavoriteListViewModelTests: XCTestCase {
    var viewModel: FavoriteListViewModel!
    var mockFavoriteDB: MockFavoriteDBStrategy!
    var itemsChangedCalled: Bool = false

    override func setUp() {
        super.setUp()
        mockFavoriteDB = MockFavoriteDBStrategy()
        let mockFavoriteDBInstance = FavoriteDB(strategy: mockFavoriteDB)
        viewModel = FavoriteListViewModel(favoriteDB: mockFavoriteDBInstance)
        viewModel.itemsChanged = { [weak self] in
            self?.itemsChangedCalled = true
        }
    }

    override func tearDown() {
        viewModel = nil
        mockFavoriteDB = nil
        itemsChangedCalled = false
        super.tearDown()
    }
    
    func testLoadFavoriteItems_LoadsItemsCorrectly() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0")
        mockFavoriteDB.products = [product1, product2]
        
        // When
        viewModel.loadFavoriteItems()
        
        // Then
        XCTAssertEqual(viewModel.favoriteItems.count, 2)
        XCTAssertEqual(viewModel.favoriteItems.first?.id, "1")
        XCTAssertEqual(viewModel.favoriteItems.last?.id, "2")
        XCTAssertTrue(itemsChangedCalled)
    }
    
    func testRemoveItem_RemovesItemCorrectly() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0")
        mockFavoriteDB.products = [product1, product2]
        viewModel.loadFavoriteItems()
        
        // When
        viewModel.removeItem(at: 0)
        
        // Then
        XCTAssertEqual(viewModel.favoriteItems.count, 1)
        XCTAssertEqual(viewModel.favoriteItems.first?.id, "2")
        XCTAssertTrue(itemsChangedCalled)
    }
}
