//
//  Customer.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 23..
//

import Foundation
import FirebaseFirestoreSwift

struct Customer : Codable {
    var id : String?
    var personalData : Datas
    //let billingInformation : Datas
    
    var products : [Product]?
    var worksheets : [Worksheet]?
    
    var joinDate : Date?
    
    func toDictionary() -> [String : Any] {
        var dict : [String : Any] = [:]
        dict["personalData"] = [
            "address" : [
                "city" : personalData.address.city,
                "street" : personalData.address.city,
                "postcode" : personalData.address.postcode
            ],
            "email" : personalData.email,
            "name" : personalData.name,
            "phone" : personalData.phone
        ]
        
        if personalData.tax != nil {
            var existingItems = dict["personalData"] as? [String: Any] ?? [String: Any]()
            existingItems["tax"] = personalData.tax!
            dict["personalData"] = existingItems
        }
        
        return dict
    }
}

struct Datas : Codable {
    let address : Address
    let email : String
    let name : String
    let phone : String
    var tax : String?
}

struct Address : Codable {
    let city : String
    let street : String
    let postcode : String
}
