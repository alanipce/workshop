//
//  BarbellLoadCalculatorTests.swift
//  workshopTests
//
//  Created by Alan Perez on 5/26/21.
//

import XCTest

@testable import workshop

class BarbellLoadCalculatorTests: XCTestCase {
  func testOptimalPlateConfiguration() throws {
    let calculator = BarbellLoadCalculator(barbell: .standard)

    // p45 as an option
    let result1 = try calculator.calculateOptimalPlateConfiguration(to: 135, with: [.p45, .p45])
    XCTAssertEqual(result1, [.p45])

    let result2 = try calculator.calculateOptimalPlateConfiguration(to: 135, with: [.p35, .p10])
    XCTAssertEqual(result2, [.p35, .p10])

    let result3 = try calculator.calculateOptimalPlateConfiguration(to: 135, with: [.p35, .p10, .p45, .p45])
    XCTAssertEqual(result3, [.p45])

    let result4 = try calculator.calculateOptimalPlateConfiguration(to: 135, with: [.p25])
    XCTAssertNil(result4)

    let result5 = try calculator.calculateOptimalPlateConfiguration(to: 45, with: [.p45])
    XCTAssertEqual(result5, [])

    XCTAssertThrowsError(try calculator.calculateOptimalPlateConfiguration(to: 10_300, with: [.p45, .p45, .p45, .p45,]))

    XCTAssertThrowsError(try calculator.calculateOptimalPlateConfiguration(to: 0, with: [.p45]))
  }
}
