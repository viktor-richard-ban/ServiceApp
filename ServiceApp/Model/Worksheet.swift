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
    var customerId : String
    var customerName : String?
    var customerCity : String?
    var productId : String
    var product : Product?
    
    var reason : String?
    var errorDescription : String?
    var isWarrianty : Bool?
    
    var acceptanceMode : String?
    var accessories : [String]?
    var userId : String
    var date : Date
    
    
    var status : String
    //var price : Int
    //var closedId : String?
    //var closedDate : Date?
    
    var dateString : String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: date)
    }
    
}
