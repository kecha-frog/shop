//
//  ReviewServiceTest.swift
//  shopTests
//
//  Created by Ke4a on 13.09.2022.
//

@testable import shop
import XCTest

class ReviewServiceTest: XCTestCase {
    // MARK: - Properties

    var network: NetworkMock!
    var parser: DecoderResponseProtocol!
    var service: ReviewsProductService!

    // MARK: - Initialization

    override func setUp() {
        super.setUp()
        network = .init()
        parser = DecoderResponse()
        service = .init(network, parser)
    }

    // MARK: - Deinitialization

    override func tearDown() {
        network = nil
        service = nil
        parser = nil
        super.tearDown()
    }

    // MARK: - Methods

    /// Test double fetch.
    /// The first request for data is checked. The second request is getting data and difference from the first one.
    func testFetchCatalogDouble() {
        var lastFetch: ResponseReviewsProductModel?

        let expectationFirst = expectation(description: "ReviewServiceTestFirst")

        service.fetchAsync()
        network.completionRequest = {
            expectationFirst.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(service.data)
        lastFetch = service.data

        let expectationSecond = expectation(description: "ReviewServiceTestSecond")

        service.fetchAsync()
        network.completionRequest = {
            expectationSecond.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(lastFetch)
        XCTAssertNotEqual(lastFetch?.items.first?.idUser, service.data?.items.first?.idUser)
    }
}
