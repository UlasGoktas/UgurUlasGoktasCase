//
//  ProductListViewModelTest.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 28.08.2024.
//

import XCTest
@testable import UgurUlasGoktasCase

final class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockCartDB: MockCartDB!
    var mockFavoriteDB: MockFavoriteDB!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        let mockCartStrategy = MockCartDBStrategy()
        mockCartDB = MockCartDB(strategy: mockCartStrategy)
        mockFavoriteDB = MockFavoriteDB()
        viewModel = ProductListViewModel(
            networkManager: mockNetworkManager,
            cartDB: mockCartDB,
            favoriteDB: FavoriteDB(strategy: mockFavoriteDB)
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockCartDB = nil
        mockFavoriteDB = nil
        super.tearDown()
    }
    
    func testFetchProductList_Success() {
        // Given
        mockNetworkManager.jsonFileName = "mockProducts"
        let expectation = self.expectation(description: "Products fetch successfully from JSON")
        
        // When
        viewModel.fetchProductList {
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.viewModel.products.count, 2)
            XCTAssertEqual(self.viewModel.products.first?.name, "Product 1")
        }
    }
    
    func testFetchProductList_Failure() {
        // Given
        mockNetworkManager.shouldReturnError = true
        let expectation = self.expectation(description: "Products fetch fails")
        
        // When
        viewModel.fetchProductList {
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.viewModel.products.count, 0)
        }
    }
    
    func testApplyFilters_BrandFilter() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0")
        viewModel.products = [product1, product2]
        viewModel.selectedFilters = ["Brand": ["BrandA"]]
        
        // When
        viewModel.applyFiltersAndSearch {}
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
        XCTAssertEqual(viewModel.filteredProducts.first?.brand, "BrandA")
    }
    
    func testSortProducts_ByPriceLowToHigh() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "20.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "10.0")
        viewModel.products = [product1, product2]
        viewModel.selectedSortOption = .priceLowToHigh
        
        // When
        viewModel.applyFiltersAndSearch {}
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.first?.price, "10.0")
    }
    
    func testAddToCart() {
        // Given
        let product = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        
        // When
        viewModel.addToCart(product: product)
        
        // Then
        XCTAssertEqual(mockCartDB.products.count, 1)
        XCTAssertEqual(mockCartDB.products.first?.name, "Product 1")
    }
    
    func testToggleFavorite_AddAndRemoveFavorite() {
        // Given
        let product = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        
        // When
        viewModel.toggleFavorite(product: product)
        
        // Then
        XCTAssertTrue(viewModel.isFavorite(product: product))
        
        // When
        viewModel.toggleFavorite(product: product)
        
        // Then
        XCTAssertFalse(viewModel.isFavorite(product: product))
    }
    
    func testFilterProducts_BySearchText() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Gadget", price: "20.0")
        viewModel.products = [product1, product2]
        let searchText = "Product"
        
        // When
        viewModel.filterProducts(by: searchText) {}
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
        XCTAssertEqual(viewModel.filteredProducts.first?.name, "Product 1")
    }
    
    func testSortSelections_ReturnsAllSortOptions() {
        // Given
        let expectedSortOptions = ["Old to new", "New to old", "Price high to low", "Price low to high"]
        
        // When
        let sortOptions = viewModel.sortSelections
        
        // Then
        XCTAssertEqual(sortOptions, expectedSortOptions)
    }
    
    func testGetFilterOptions_ReturnsCorrectFilterOptions() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: "ModelX", name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: "ModelY", name: "Product 2", price: "20.0")
        viewModel.products = [product1, product2]
        
        // When
        let filterOptions = viewModel.getFilterOptions()
        
        // Then
        XCTAssertEqual(filterOptions.count, 2)
        XCTAssertEqual(filterOptions[0]["Brand"], ["BrandA", "BrandB"])
        XCTAssertEqual(filterOptions[1]["Model"], ["ModelX", "ModelY"])
    }
    
    func testApplyFilters_AppliesBrandAndSortFilter() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "20.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "10.0")
        viewModel.products = [product1, product2]
        
        // When
        viewModel.applyFilters(selectedFilters: ["Brand": ["BrandA"]], sortSelection: "priceLowToHigh") {}
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
        XCTAssertEqual(viewModel.filteredProducts.first?.brand, "BrandA")
    }
    
    func testSortProducts_SortsByOldToNew() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: "2024-01-01T10:00:00Z", description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: "2023-01-01T10:00:00Z", description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0")
        viewModel.filteredProducts = [product1, product2]
        viewModel.selectedSortOption = .oldToNew
        
        // When
        viewModel.sortProducts()
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.first?.id, "1")
        XCTAssertEqual(viewModel.filteredProducts.last?.id, "2")
    }
    
    func testSortProducts_SortsByNewToOld() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: "2023-01-01T10:00:00Z", description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: "2024-01-01T10:00:00Z", description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0")
        viewModel.filteredProducts = [product1, product2]
        viewModel.selectedSortOption = .newToOld
        
        // When
        viewModel.sortProducts()
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.first?.id, "1")
        XCTAssertEqual(viewModel.filteredProducts.last?.id, "2")
    }
    
    func testSortProducts_SortsByPriceHighToLow() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0")
        viewModel.filteredProducts = [product1, product2]
        viewModel.selectedSortOption = .priceHighToLow
        
        // When
        viewModel.sortProducts()
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.first?.price, "20.0")
        XCTAssertEqual(viewModel.filteredProducts.last?.price, "10.0")
    }
    
    func testSortProducts_SortsByPriceLowToHigh() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "20.0")
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "10.0")
        viewModel.filteredProducts = [product1, product2]
        viewModel.selectedSortOption = .priceLowToHigh
        
        // When
        viewModel.sortProducts()
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.first?.price, "10.0")
        XCTAssertEqual(viewModel.filteredProducts.last?.price, "20.0")
    }
}
