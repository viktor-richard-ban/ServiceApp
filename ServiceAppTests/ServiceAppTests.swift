//
//  ServiceAppTests.swift
//  ServiceAppTests
//
//  Created by Bán Viktor on 2021. 03. 22..
//

import XCTest
@testable import ServiceApp

class ServiceAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCorrectProduct() {
        let productWithoutNilVariable = Product(id: "00001", customerId: "00005", pin: 9999, name: "Robi", productNumber: "193241ab", productType: "Robotfűnyíró", serialNumber: "986284gb", purchaseDate: "2020")
        
        let resultDictionary = productWithoutNilVariable.dictionary
        
        XCTAssertEqual(resultDictionary["customerId"] as? String, "00005")
        XCTAssertEqual(resultDictionary["pin"] as? Int, 9999)
        XCTAssertEqual(resultDictionary["productName"] as? String, "Robi")
        XCTAssertEqual(resultDictionary["productNumber"] as? String, "193241ab")
        XCTAssertEqual(resultDictionary["productType"] as? String, "Robotfűnyíró")
        XCTAssertEqual(resultDictionary["serialNumber"] as? String, "986284gb")
        XCTAssertEqual(resultDictionary["purchaseDate"] as? String, "2020")
    }
    
    func testNotCorrectProduct() throws {
        let productWithNilVariable = Product(id: "00001", customerId: "00005", pin: nil, name: "Robi", productNumber: "193241ab", productType: "Robotfűnyíró", serialNumber: "986284gb", purchaseDate: nil)
        
        let resultDictionary = productWithNilVariable.dictionary
        
        XCTAssertEqual(resultDictionary["customerId"] as? String, "00005")
        XCTAssertNotEqual(resultDictionary["pin"] as? Int, 1234)
        XCTAssertEqual(resultDictionary["productName"] as? String, "Robi")
        XCTAssertEqual(resultDictionary["productNumber"] as? String, "193241ab")
        XCTAssertEqual(resultDictionary["productType"] as? String, "Robotfűnyíró")
        XCTAssertEqual(resultDictionary["serialNumber"] as? String, "986284gb")
        XCTAssertEqual(resultDictionary["purchaseDate"] as? String, nil)
    }

    func testPerformanceExample() throws {
        let product = Product(id: "00001", customerId: "00005", pin: 9999, name: "Robi", productNumber: "193241ab", productType: "Robotfűnyíró", serialNumber: "986284gb", purchaseDate: "2020")
        
        measure {
            let _ = product.dictionary
        }
    }

}
