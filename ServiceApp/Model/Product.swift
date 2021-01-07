//
//  Product.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 25..
//

import Foundation
import FirebaseFirestoreSwift

struct Product : Codable {
    var customerId : String?
    var productId : String?
    var pin : Int?
    var productName : String
    var productNumber : String?
    var productType : String?
    var serialNumber : String?
    var purchaseDate : String?
}
