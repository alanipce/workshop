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
    
    let result6 = try calculator.calculateOptimalPlateConfiguration(to: 260, with: [.p45, .p45, .p35, .p25, .p15, .p2_5])
    XCTAssertEqual(result6, [.p45, .p45, .p15, .p2_5])
    
    // sometimes adding lighter plates together is the optimal solution based on plates available
    // 45+5+5+5 = 35+25 given a user only has 45, 25, 35, 5,5,5 plates
    let result7 = try calculator.calculateOptimalPlateConfiguration(to: 165, with: [.p45, .p35, .p25, .p5, .p5, .p5])
    XCTAssertEqual(result7, [.p35, .p25])

    XCTAssertThrowsError(try calculator.calculateOptimalPlateConfiguration(to: 10_300, with: [.p45, .p45, .p45, .p45,]))
    XCTAssertThrowsError(try calculator.calculateOptimalPlateConfiguration(to: 0, with: [.p45]))
  }
}
