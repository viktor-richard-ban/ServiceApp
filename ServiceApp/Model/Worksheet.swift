//
//  Worksheet.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 27..
//

import Foundation

struct Worksheet {
    var customer : Customer?
    var product : Product?
    
    var reason : worksheetReason?
    var errorDescription : String?
    
    var acceptanceMode :workSheetAcceptanceMode?
    var accessories : [String]?
    var userId : String?
    var date : Date?
    
    
    var status : workSheetStatus?
    var closedId : String?
    var closedDate : Date?
    
}

enum worksheetReason {
    case service
    case maintenance
}

enum workSheetStatus {
    case open
    case close
}

enum workSheetAcceptanceMode {
    case personal
    case site   // on site
    case cod // cash on delivery
}
