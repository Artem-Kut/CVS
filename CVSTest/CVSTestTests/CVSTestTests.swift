//
//  CVSTestTests.swift
//  CVSTestTests
//
//  Created by Artem Kutasevych on 12/7/24.
//

import XCTest
@testable import CVSTest

final class ListViewModelTests: XCTestCase {
 
    private var sut: ListViewModel!
    private var networkService = NetworkServiceMock()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListViewModel(networkService: networkService)
    }
    
    func testGetItemsSuccess() {
        // given
        let title = "TestTitle"
        let media = LinkPhoto(m: "")
        
        let item = Item(title: title, link: "", media: media, dateTaken: Date(), description: "", published: "", author: "", tags: "")
        let expectedValue = Items(items: [item])
        networkService.itemsReturnValue = expectedValue
        let exp = expectation(description: "Loading items")
        
        // when
        sut.fetchItems(for: "")
        networkService.closure = {
            exp.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(networkService.getItemsCalled)
        XCTAssertEqual(title, networkService.itemsReturnValue.items.first?.title)
    }
    
    func testGetItemsFailure() {
        // given
        let error: APIError = .errorResponce
        networkService.error = error
        let exp = expectation(description: "Loading items")
        
        // when
        sut?.fetchItems(for: "")
        networkService.closure = {
            exp.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(networkService.getItemsCalled)
        XCTAssertEqual(error, networkService.error)
    }
}
