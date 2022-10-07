//
//  StringTests.swift
//  GadwalTests
//
//  Created by nader said on 02/10/2022.
//

import XCTest
@testable import Gadwal

class StringTests: XCTestCase
{
    let str = "nader"

    func testNegativeSubscriptIndex()
    {
        XCTAssertEqual(str[-1], "")
        XCTAssertEqual(str[-2], "")
        XCTAssertEqual(str[-10], "")
    }
    
    func testOutOfRangeSubscript()
    {
        XCTAssertEqual(str[7], "")
        XCTAssertEqual(str[8], "")
        XCTAssertEqual(str[10], "")
    }
    
    func testSubscript()
    {
        XCTAssertEqual(str[0], "n")
        XCTAssertEqual(str[1], "a")
        XCTAssertEqual(str[2], "d")
        XCTAssertEqual(str[3], "e")
        XCTAssertEqual(str[4], "r")
    }
}
