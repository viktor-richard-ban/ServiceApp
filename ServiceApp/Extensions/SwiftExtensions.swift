//
//  SwiftExtensions.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 04. 12..
//

import Foundation

extension Date {
    
    func dateStringWith(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
