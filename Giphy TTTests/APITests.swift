//
//  APITests.swift
//  Giphy TTTests
//
//  Created by Artūrs Oļehno on 30/01/2024.
//

import XCTest
import RxSwift
@testable import Giphy_TT


final class APITests: XCTestCase {
    
    func testEncode() {
        let query = "Any search Text"
        let encodedQuery = APIManager.shared.encode(query)
        XCTAssertNotNil(encodedQuery, "Encoded query should not be nil")
        let manuallyEncodedQuery = manuallyEncode(query)
        XCTAssertEqual(encodedQuery, manuallyEncodedQuery, "Encoded query should match manually encoded query")
    }
    
    private func manuallyEncode(_ query: String) -> String? {
        let allowedCharacters = CharacterSet.urlHostAllowed
        return query.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    func testCreateUrl() {
        let query = APIManager.shared.encode("Any search Text")
        let offset = 21
        let url = APIManager.shared.createUrl(query: query!, offset: offset)
        XCTAssertNotNil(url, "URL should not be nil")
        let expectedURLString = "\(Constants.API_URL)api_key=\(Constants.API_KEY)&q=\(query!)&offset=\(offset)&limit=20"
        XCTAssertEqual(url?.absoluteString, expectedURLString, "Generated URL should match the expected URL")
    }
    
    func testDecodeGifsResponse() {
        let gifData = """
            {
                "data": [
                    {
                        "id": "3o7527pa7qs9kCG78A",
                        "type": "gif",
                        "title": "What Is It Reaction GIF by Nebraska Humane Society",
                        "images": {
                            "original": {
                                "url": "https://media2.giphy.com/media/3o7527pa7qs9kCG78A/giphy.gif?cid=3bf8c0e6qn03294vig554v9unnlv06myt04zk99tnlnj0886&ep=v1_gifs_search&rid=giphy.gif&ct=g"
                            }
                        }
                    },
                    {
                        "id": "gFW9rRpOkMRBY2KF6s",
                        "type": "gif",
                        "title": "dog GIF",
                        "images": {
                            "original": {
                                "url": "https://media4.giphy.com/media/gFW9rRpOkMRBY2KF6s/giphy.gif?cid=3bf8c0e6qn03294vig554v9unnlv06myt04zk99tnlnj0886&ep=v1_gifs_search&rid=giphy.gif&ct=g"
                            }
                        }
                    }
                ]
            }
        """.data(using: .utf8)
        
        let observer = TestObserver<Result<[Gif], Error>>()
        let anyObserver = AnyObserver<Result<[Gif], Error>> { event in
            observer.on(event)
        }
        
        APIManager.shared.decodeGifsResponse(data: gifData!, observer: anyObserver)
        
        XCTAssertEqual(observer.events.count, 2, "Observer should receive two event")
        guard let firstEvent = observer.events.first else {
            XCTFail("Observer should receive at least two event.")
            return
        }
        
        switch firstEvent {
        case .next(let result):
            switch result {
            case .success(let gifs):
                XCTAssertEqual(gifs.count, 2, "Expected 2 gifs in the success event")
            case .failure(let error):
                XCTFail("Expected success, but received failure: \(error)")
            }
        case .error(let error):
            XCTFail("Expected a next event, but received an error event: \(error)")
        case .completed:
            XCTFail("Expected a next event, but received a completion event.")
        }
    }
    
    func testErrorHandler() {
        let expectation = self.expectation(description: "API Error Handler")
        
        let observer: AnyObserver<Result<[Gif], Error>> = AnyObserver { event in
            switch event {
            case .error(let error):
                XCTAssertNotNil(error as? APIError)
                XCTAssertEqual(error as? APIError, APIError.failedToGetData)
                expectation.fulfill()
            default:
                break
            }
        }
        
        APICaller.shared.errorHandler(observer: observer)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class TestObserver<Element>: ObserverType {
    var events: [Event<Element>] = []
    
    func on(_ event: Event<Element>) {
        events.append(event)
    }
}
