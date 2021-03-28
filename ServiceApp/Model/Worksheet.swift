//
//  Worksheet.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 27..
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Worksheet : Codable {
    
    var id : String?
    var customerId : String
    var productId: String
    
    var customer: Customer? = nil
    var product: Product? = nil
    
    var reason : String?
    var errorDescription : String?
    var isWarrianty : Bool = false
    
    var acceptanceMode : String?
    var accessories : [String]?
    
    var date : Date
    
    var status : String
    var userId : String = "123abc"
    //var price : Int = 0
    //var closedId : String?
    //var closedDate : Int?
    
    
    var dictionary: [String:Any] {
        var dict : [String : Any] = [:]
        
        //Required fields
        dict["customerId"] = customerId
        dict["productId"] = productId
        dict["isWarrianty"] = isWarrianty
        dict["date"] = date
        dict["status"] = status
        
        //dict["userId"] = userId
        //dict["price"] = 0
        
        //Worksheet
        if let reason = reason {
            dict["reason"] = reason
        }
        if let error = errorDescription {
            dict["errorDescription"] = error
        }
        if let acceptanceMode = acceptanceMode {
            dict["acceptanceMode"] = acceptanceMode
        }
        if let accessories = accessories {
            dict["accessories"] = accessories
        }
        
        return dict
    }
    
}

extension Worksheet {
    init?(initDictionary: [String:Any]) {
        let customerId = initDictionary["customerId"] as! String
        let productId = initDictionary["productId"] as! String
        let reason = initDictionary["reason"] as? String
        let errorDescription = initDictionary["errorDescription"] as? String
        let isWarrianty = initDictionary["isWarrianty"] as! Bool
        let acceptanceMode = initDictionary["acceptanceMode"] as? String
        let accessories = initDictionary["accessories"] as? [String]
        
        let timestamp: Timestamp = (initDictionary["date"] as AnyObject) as! Timestamp
        let date = timestamp.dateValue()
        
        let status = initDictionary["status"] as! String
        
        self.init(id: nil, customerId: customerId, productId: productId, customer: nil, product: nil, reason: reason, errorDescription: errorDescription, isWarrianty: isWarrianty, acceptanceMode: acceptanceMode, accessories: accessories, date: date, status: status, userId: "")
    }
}
