import XCTest
@testable import Giphy_TT



class DetailViewControllerTests: XCTestCase {
    
    var detailViewController: DetailViewController!
    
    override func setUp() {
        super.setUp()
        detailViewController = DetailViewController()
        // Load the view hierarchy
        detailViewController.loadViewIfNeeded()
    }
    
    func testConfigureMethod() {
        let gif: Gif = Gif(id: "testID", type: "Gif", title: "Test Title", import_datetime: "2024-01-06T12:00:00Z", images: Images(original: Original(url: "")))
        XCTAssertEqual(detailViewController.idLabel.text, "ID")
        XCTAssertEqual(detailViewController.titleLabel.text, "Title")
        XCTAssertEqual(detailViewController.publishDateLabel.text, "Publication Date")
        }
    
    override func tearDown() {
        detailViewController = nil
        super.tearDown()
    }
}
