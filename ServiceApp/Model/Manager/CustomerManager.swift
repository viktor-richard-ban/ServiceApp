//
//  CustomerManager.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2021. 01. 02..
//

import Foundation
import Firebase

protocol CustomerManagerDelegate {
    func updateCustomers(customers : [Customer])
    func customerCreated(with: String)
}

struct CustomerManager {
    
    let db = Firestore.firestore()
    var delegate : CustomerManagerDelegate?
    
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
                        customers.append(customer)
                    } catch {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    delegate?.updateCustomers(customers: customers)
                    customers = []
                }
            }
        }
    }
    
    func createCustomer(customer : [String : Any]) {
        var ref: DocumentReference? = nil
        ref = db.collection("customers").addDocument(data: customer) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            DispatchQueue.main.async {
                delegate?.customerCreated(with: String(ref!.documentID))
            }
        }
    }
    
    func updateCustomer(id: String, customerData : [String : Any]) {
        db.collection("customers").document(id).updateData(customerData) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("id: \(id)\ndata: \(customerData)")
                print("Document successfully updated")
            }
        }
    }
    
}
