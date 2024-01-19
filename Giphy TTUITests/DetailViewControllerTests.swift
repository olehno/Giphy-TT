//
//  DetailViewControllerTests.swift
//  Giphy TTUITests
//
//  Created by Artūrs Oļehno on 06/01/2024.
//

//import XCTest
//@testable import Giphy_TT
//
//
//
//class DetailViewControllerTests: XCTestCase {
//    
//    var detailViewController: DetailViewController!
//    
//    override func setUp() {
//        super.setUp()
//        detailViewController = DetailViewController()
//        // Load the view hierarchy
//        detailViewController.loadViewIfNeeded()
//    }
//    
//    func testConfigureMethod() {
//        // Given
//        let gif: Gif = Gif(id: "testID", title: "Test Title", import_datetime: "2024-01-06T12:00:00Z", images: Images(original: Original(url: "")))
//        // When
//        detailViewController.configure(with: gif)
//        // Then
//        XCTAssertEqual(detailViewController.idLabel.text, "Gif ID - \(gif.id)")
//        XCTAssertEqual(detailViewController.titleLabel.text, "Title - \(gif.title ?? "Unknown")")
//        XCTAssertEqual(detailViewController.publishDateLabel.text, "Publication Date - \(gif.import_datetime ?? "Unknown")")
//        
//        // You might want to add more assertions based on your specific requirements
//    }
//    
//    override func tearDown() {
//        detailViewController = nil
//        super.tearDown()
//    }
//}
