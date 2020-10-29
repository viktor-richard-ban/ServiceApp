//
//  Product.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 25..
//

import Foundation

struct Product : Codable {
    let customerId : String
    var pin : Int?
    let productName : String
    let productNumber : String?
    let productType : String?
    let serialNumber : String?
}
