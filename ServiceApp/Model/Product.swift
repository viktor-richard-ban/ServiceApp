//
//  Product.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 03. 15..
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Product: Codable {
    
    var id : String?
    var pin : Int?
    var name : String
    var productNumber : String?
    var productType : String
    var serialNumber : String?
    var purchaseDate : String?
    
    var dictionary: [String:Any] {
        return [
            "name": name,
            "productNumber": productNumber as Any,
            "productType": productType,
            "serialNumber": serialNumber as Any,
            "purchaseDate": purchaseDate as Any
        ]
    }
    
    
}

extension Product {
    init?(initDictionary: [String : Any]) {
        let name = initDictionary["productName"] as! String
        let productNumber = initDictionary["productNumber"] as? String
        let productType = initDictionary["productType"] as! String
        let serialNumber = initDictionary["serialNumber"] as? String
        let purchaseDate = initDictionary["purchaseDate"] as? String
        let pin = initDictionary["pin"] as? Int
        self.init(id: nil, pin: pin, name: name, productNumber:  productNumber, productType: productType, serialNumber: serialNumber, purchaseDate: purchaseDate)
    }
}
