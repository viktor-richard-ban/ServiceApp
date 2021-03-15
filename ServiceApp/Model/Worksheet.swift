//
//  Worksheet.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 27..
//

import Foundation
import FirebaseFirestoreSwift

struct Worksheet : Codable {
    
    var id : String?
    var customerId : String {
        didSet {
            
        }
    }
    var productId: String
    
    var customer: Customer? = nil
    var product: Product? = nil
    
    var reason : String?
    var errorDescription : String?
    var isWarrianty : Bool = false
    
    var acceptanceMode : String?
    var accessories : [String]?
    
    var date : Int
    var dateString : String {
        let tmp = Date(timeIntervalSince1970: TimeInterval(date/1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: tmp)
    }
    
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
        self.init(customerId: "4APY2b1Buo3amsHMSudI", productId: "", date: 2, status: "")
    }
}
