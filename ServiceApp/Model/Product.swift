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
    var customerId: String
    var pin : Int?
    var name : String
    var productNumber : String?
    var productType : String
    var serialNumber : String?
    var purchaseDate : String?
    
    var dictionary: [String:Any] {
        var dict: [String: Any] = [
            "customerId": customerId,
            "productName": name,
            "productType": productType
        ]
        
        if let productNumber = productNumber {
            dict["productNumber"] = productNumber
        }
        
        if let serialNumber = serialNumber {
            dict["serialNumber"] = serialNumber
        }
        
        if let purchaseDate = purchaseDate {
            dict["purchaseDate"] = purchaseDate
        }
        
        if let pin = pin {
            dict["pin"] = pin
        }
        
        return dict
    }
    
    
}

extension Product {
    init?(initDictionary: [String : Any]) {
        let customerId = initDictionary["customerId"] as! String
        let name = initDictionary["productName"] as! String
        let productNumber = initDictionary["productNumber"] as? String
        let productType = initDictionary["productType"] as! String
        let serialNumber = initDictionary["serialNumber"] as? String
        let purchaseDate = initDictionary["purchaseDate"] as? String
        let pin = initDictionary["pin"] as? Int
        self.init(id: nil, customerId: customerId, pin: pin, name: name, productNumber:  productNumber, productType: productType, serialNumber: serialNumber, purchaseDate: purchaseDate)
    }
}
