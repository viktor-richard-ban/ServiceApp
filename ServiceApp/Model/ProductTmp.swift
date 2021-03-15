//
//  Product.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 25..
//

import Foundation
import FirebaseFirestoreSwift

struct ProductTmp : Codable {
    var customer : CustomerTmp?
    var productId : String?
    var pin : Int?
    var productName : String
    var productNumber : String?
    var productType : String
    var serialNumber : String?
    var purchaseDate : String?
    
    func toDictionary() -> [String:Any] {
        
        var dict : [String : Any] = [
            "productName" : productName,
            "productType" : productType
        ]
        
        if productType == "robotfűnyíró" {
            if let pin = pin {
                dict["pin"] = pin
            }
        }
        
        if let pn = productNumber {
            dict["productNumber"] = pn
        }
        
        if let sn = serialNumber {
            dict["serialNumber"] = sn
        }
        
        if let pd = purchaseDate {
            dict["purchaseDate"] = pd
        }
        
        return dict
    }
}
