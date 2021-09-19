//
//  CoinHistoryCellViewModelTests.swift
//  CoinHistoryTests
//
//  Created by Satish Bandaru on 19/09/21.
//

import XCTest
@testable import CoinHistory

class CoinHistoryCellViewModelTests: XCTestCase {
    var sut: CoinHistoryCellViewModel!
    
    func testFormattedPriceString() {
        sut = CoinHistoryCellViewModel(index: 5, price: 42567.2348089)
        XCTAssertTrue(sut.formattedPriceString == "42567.23€")
        
        sut = CoinHistoryCellViewModel(index: 5, price: 24374)
        XCTAssertTrue(sut.formattedPriceString == "24374.00€")
    }
    
    func testDateString() {
        sut = CoinHistoryCellViewModel(index: 5, price: 24374)
        
        let testDate = Date(timeIntervalSince1970: 1632029605) // Sep 19, 2021
        let dateString = sut.dateString(testDate)
        XCTAssertTrue(dateString == "2021-09-14")
    }
}
