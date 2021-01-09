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
    
    var joinDate : Int?
    var joinDateString : String {
        if let join = joinDate {
            let date = Date(timeIntervalSince1970: TimeInterval(join/1000))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: date)
        }
        return "null"
    }
    
    func toDictionary() -> [String : Any] {
        var dict : [String : Any] = [:]
        dict["personalData"] = [
            "address" : [
                "city" : personalData.address.city,
                "street" : personalData.address.street,
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
        
        if let joinDate = joinDate {
            dict["joinDate"] = joinDate
        }
        
        return dict
    }
    
}

struct Datas : Codable {
    var address : Address
    var email : String
    var name : String
    var phone : String
    var tax : String?
}

struct Address : Codable {
    var city : String
    var street : String
    var postcode : String
}
