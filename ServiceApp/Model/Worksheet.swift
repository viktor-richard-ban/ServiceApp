//
//  Worksheet.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 27..
//

import Foundation
import FirebaseFirestoreSwift

struct Worksheet : Codable {
    var worksheetId : String?
    var customerId : String
    var customerName : String?
    var customerCity : String?
    var productId : String
    var productName : String?
    var serialNumber : String?
    var purchaseDate : Int?
    
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
    
    var purchaseDateString : String {
        let tmp = Date(timeIntervalSince1970: TimeInterval((purchaseDate ?? 0)/1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: tmp)
    }
    
    var status : String
    var userId : String = "123abc"
    var price : Int = 0
    //var closedId : String?
    //var closedDate : Int?
    
    
    func toDictionary() -> [String:Any] {
        var dict : [String : Any] = [:]
        
        //Required fields
        dict["customerId"] = customerId
        dict["productId"] = productId
        dict["isWarrianty"] = isWarrianty
        dict["date"] = date
        dict["status"] = status
        dict["userId"] = userId
        dict["price"] = 0
        
        //Customer
        if let customerName = customerName {
            dict["customerName"] = customerName
        }
        if let customerCity = customerCity {
            dict["customerCity"] = customerCity
        }
        
        //Product
        if let productName = productName {
            dict["productName"] = productName
        }
        if let serialNumber = serialNumber {
            dict["serialNumber"] = serialNumber
        }
        if let purchaseDate = purchaseDate {
            dict["purchaseDate"] = purchaseDate
        }
        
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
