//
//  CustomerManager.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2021. 01. 02..
//

import Foundation
import Firebase

protocol customerManagerDelegate {
    func updateCustomers(customers : [Customer])
    func updateCustomer(customer : Customer)
}

struct CustomerManager {
    
    let db = Firestore.firestore()
    var delegate : customerManagerDelegate?
    
    func fetchCustomers() {
        var customers : [Customer] = []
        
        db.collection("customers").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var customer = try JSONDecoder().decode(Customer.self, from: jsonData)
                        customer.id = document.documentID
                        print(customer.id!)
                        customers.append(customer)
                    } catch {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    delegate?.updateCustomers(customers: customers)
                }
            }
        }
    }
    
    func fetchCustomers(id: String) {
        
        db.collection("customers").document(id).addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: querySnapshot!.data()!)
                        var customer = try JSONDecoder().decode(Customer.self, from: jsonData)
                        customer.id = querySnapshot?.documentID
                        delegate?.updateCustomer(customer: customer)
                    } catch {
                        print(error)
                    }
            }
        }
    }
    
}
