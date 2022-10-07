//
//  ColorTests.swift
//  GadwalTests
//
//  Created by nader said on 02/10/2022.
//

import XCTest
import SwiftUI
@testable import Gadwal

class ColorTests: XCTestCase
{

    func testColorWithWrongType()
    {
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "", subDepartmentNumber: nil, mandatory: true))
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "", subDepartmentNumber: nil, mandatory: false))
    }

    func testColorWithWrongSubDepartmentNumber()
    {
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "", subDepartmentNumber: 3, mandatory: true))
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "", subDepartmentNumber: 4, mandatory: false))
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "", subDepartmentNumber: -1, mandatory: true))
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "", subDepartmentNumber: -5, mandatory: false))
    }
    
    func testColorWithCorrectTypeAndMandatory()
    {
        XCTAssertEqual(Color.black, Color.getTypeColor(type: "متطلبات جامعة", subDepartmentNumber: nil, mandatory: true))
        XCTAssertEqual(Color.color5, Color.getTypeColor(type: "تخدم التخصص", subDepartmentNumber: nil, mandatory: true))
        XCTAssertEqual(Color.color6, Color.getTypeColor(type:"متطلبات كلية", subDepartmentNumber: nil, mandatory: true))
    }
    
    func testColorWithCorrectTypeAndNotMandatory()
    {
        XCTAssertEqual(Color.color1, Color.getTypeColor(type: "تخدم التخصص", subDepartmentNumber: nil, mandatory: false))
        XCTAssertEqual(Color.color2, Color.getTypeColor(type:"متطلبات كلية", subDepartmentNumber: nil, mandatory: false))
    }
    
    func testColorWithCorrectSubDepartmentNumberAndMandatory()
    {
        XCTAssertEqual(Color.color7, Color.getTypeColor(type: "", subDepartmentNumber: 0, mandatory: true))
        XCTAssertEqual(Color.color8, Color.getTypeColor(type: "", subDepartmentNumber: 1, mandatory: true))
    }
    
    func testColorWithCorrectSubDepartmentNumberAndNotMandatory()
    {
        XCTAssertEqual(Color.color3, Color.getTypeColor(type: "", subDepartmentNumber: 0, mandatory: false))
        XCTAssertEqual(Color.color4, Color.getTypeColor(type: "", subDepartmentNumber: 1, mandatory: false))
    }
}
