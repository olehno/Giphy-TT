//
//  Giphy_TTTests.swift
//  Giphy TTTests
//
//  Created by Artūrs Oļehno on 23/12/2023.
//

import XCTest
@testable import Giphy_TT

final class Giphy_TTTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetGifs() throws {
            let query = "cats"
            let offset = 0
            let expectation = XCTestExpectation(description: "Get Gifs")
            
        APICaller.shared.getGifs(with: query, offset: offset) { result in
                switch result {
                case .success(let gifs):
                    XCTAssertFalse(gifs.isEmpty, "Gifs array should not be empty on success")
                case .failure(let error):
                    XCTFail("Unexpected failure: \(error)")
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 10.0)
        }
}

