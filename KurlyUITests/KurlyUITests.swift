//
//  KurlyUITests.swift
//  KurlyUITests
//
//  Created by Den Jo on 2023/01/21.
//

import XCTest

final class KurlyUITests: XCTestCase {
    
    /*
     Put setup code here. This method is called before the invocation of each test method in the class.
     In UI tests it is usually best to stop immediately when a failure occurs.
     In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
     */
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSearch() {
        let applications = XCUIApplication()
        applications.launch()
        
        let searchField = applications.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("swift")
        
        applications.keyboards.buttons["search"].tap()
        
        let scrollView = applications.scrollViews.firstMatch
        XCTAssertFalse(scrollView.otherElements.count <= 0)
    }
}
