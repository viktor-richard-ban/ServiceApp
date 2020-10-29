//
//  Customer.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 23..
//

import Foundation

struct Customer : Codable {
    var id : String?
    let personalDatas : Datas
    //let billingInformation : Datas
}

struct Datas : Codable {
    let address : Address
    let email : String
    let name : String
    let phone : String
    let tax : String?
}

struct Address : Codable {
    let city : String
    let street : String
    let postcode : String
}
