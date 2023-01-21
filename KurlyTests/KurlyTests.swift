//
//  KurlyTests.swift
//  KurlyTests
//
//  Created by Den Jo on 2023/01/21.
//

import XCTest
@testable import Kurly

final class KurlyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testKeywords() async throws {
        let _ = try await SearchCoreDataManager.shared.requestKeywords()
    }
    
    func testSearchResult() throws {
        let data = SearchResultData()
        data.request(keyword: "swift")
        
        let expectation = XCTestExpectation(description: "testSearchResult")
        
        let _ = data.$repositories
            .sink {
                XCTAssertTrue($0.isEmpty)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5)
    }
}
