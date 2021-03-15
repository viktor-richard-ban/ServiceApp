//
//  Customer.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 03. 14..
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Customer: Codable {
    
    var id: String?
    var personalData: PersonalData
    var lastActivity: Date
    var lastActivityString : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: lastActivity)
    }
    var joinDate: Date
    var joinDateString : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: joinDate)
    }
    
    var products: [Product] = []
    var worksheets: [Worksheet] = []
    
    var dictionary: [String: Any] {
        return [
            "personalData": personalData,
            "lastActivity": lastActivity,
            "joinDate": Timestamp(date: joinDate)
        ]
    }
}

struct PersonalData : Codable {
    var address : Address?
    var email : String?
    var name : String?
    var phone : String?
    var tax : String?
}

struct Address : Codable {
    var city : String?
    var street : String?
    var postcode : String?
}

extension Customer {
    init?(initDictionary: [String : Any]) {
        let personalDataLevel = initDictionary["personalData"] as! [String:Any]
        let personalData = PersonalData(initDictionary: personalDataLevel)!
        
        let timestamp: Timestamp = (initDictionary["lastActivity"] as AnyObject) as! Timestamp
        let lastActivity = timestamp.dateValue()
        
        let optionalTimestamp: Timestamp? = (initDictionary["joinDate"] as AnyObject) as? Timestamp
        if let joinDate = optionalTimestamp?.dateValue() {
            self.init(personalData: personalData, lastActivity: lastActivity, joinDate: joinDate)
        } else {
            self.init(personalData: personalData, lastActivity: lastActivity, joinDate: Date())
        }
    }
}

extension PersonalData {
    init?(initDictionary: [String : Any]) {
        let addressLevel = initDictionary["address"] as! [String:Any]
        let address = Address(initDictionary: addressLevel)!
        let email = initDictionary["email"] as? String
        let name = initDictionary["name"] as! String
        let phone = initDictionary["phone"] as? String
        let tax = initDictionary["tax"] as? String
        self.init(address: address, email: email, name: name, phone: phone, tax: tax)
    }
}

extension Address {
    init?(initDictionary: [String : Any]) {
        let city = initDictionary["city"] as! String
        let street = initDictionary["street"] as! String
        let postcode = initDictionary["postcode"] as! String
        self.init(city: city, street: street, postcode: postcode)
    }
}
