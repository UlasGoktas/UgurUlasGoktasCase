//
//  CartViewModelTest.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 29.08.2024.
//

import XCTest
@testable import UgurUlasGoktasCase

final class CartViewModelTests: XCTestCase {
    var viewModel: CartViewModel!
    var mockCartDBStrategy: MockCartDBStrategy!
    var mockCartDB: MockCartDB!
    
    override func setUp() {
        super.setUp()
        mockCartDBStrategy = MockCartDBStrategy()
        mockCartDB = MockCartDB(strategy: mockCartDBStrategy)
        viewModel = CartViewModel(cartDB: mockCartDB)
    }

    override func tearDown() {
        viewModel = nil
        mockCartDBStrategy = nil
        mockCartDB = nil
        super.tearDown()
    }
    
    func testTotalPrice_CalculatesCorrectly() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0", quantity: 2)
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0", quantity: 1)
        mockCartDBStrategy.products = [product1, product2]
        
        // When
        viewModel.loadCartItems()
        let totalPrice = viewModel.totalPrice
        
        // Then
        XCTAssertEqual(totalPrice, "40.0 \(TextConstants.turkishLiraCurrency.rawValue)")
    }
    
    func testLoadCartItems_LoadsItemsCorrectly() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0", quantity: 1)
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0", quantity: 2)
        mockCartDBStrategy.products = [product1, product2]
        
        // When
        viewModel.loadCartItems()
        
        // Then
        XCTAssertEqual(viewModel.cartItems.count, 2)
        XCTAssertEqual(viewModel.cartItems.first?.id, "1")
        XCTAssertEqual(viewModel.cartItems.last?.id, "2")
    }
    
    func testDecreaseQuantity_DecreasesProductQuantity() {
        // Given
        let product = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0", quantity: 2)
        mockCartDBStrategy.products = [product]
        
        // When
        viewModel.loadCartItems()
        viewModel.decreaseQuantity(of: product)
        
        // Then
        XCTAssertEqual(mockCartDBStrategy.products.first?.quantity, 1)
    }
    
    func testDecreaseQuantity_RemovesProductIfQuantityIsOne() {
        // Given
        let product = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0", quantity: 1)
        mockCartDBStrategy.products = [product]
        
        // When
        viewModel.loadCartItems()
        viewModel.decreaseQuantity(of: product)
        
        // Then
        XCTAssertEqual(mockCartDBStrategy.products.count, 0)
    }
    
    func testCompletePurchase_ClearsCart() {
        // Given
        let product1 = Product(brand: "BrandA", createdAt: nil, description: nil, id: "1", image: nil, model: nil, name: "Product 1", price: "10.0", quantity: 1)
        let product2 = Product(brand: "BrandB", createdAt: nil, description: nil, id: "2", image: nil, model: nil, name: "Product 2", price: "20.0", quantity: 2)
        mockCartDBStrategy.products = [product1, product2]
        
        // When
        viewModel.completePurchase()
        
        // Then
        XCTAssertEqual(mockCartDBStrategy.products.count, 0)
    }
}
