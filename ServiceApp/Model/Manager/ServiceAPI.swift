//
//  ServiceAPI.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 03. 14..
//

import Foundation
import Firebase

protocol ServiceAPIDelegate {
    func didCustomersRetrieved(customers: [Customer])
    func didCustomersProductsRetrieved(products: [Product])
    func didCustomersWorksheetsRetrieved(worksheet: [Worksheet])
}

protocol PrivateServiceAPIDelegate {
    func didCustomerRetrieved(customer: Customer)
}

struct ServiceAPI {
    
    private let db = Firestore.firestore()
    var delegate: ServiceAPIDelegate?
    
    //MARK: Customers
    func getFirstTenCustomers() {
        db.collection("customers").order(by: "lastActivity", descending: true).limit(to: 10)
            .addSnapshotListener { querySnapshot, error in
                guard (querySnapshot?.documents) != nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let models = querySnapshot!.documents.map { (document) -> Customer in
                    if var model = Customer(initDictionary: document.data()) {
                        model.id = document.documentID
                        return model
                    } else {
                          preconditionFailure("Unable to initialize type \(Customer.self) with dictionary \(document.data())")
                    }
                }
                DispatchQueue.main.async {
                    delegate?.didCustomersRetrieved(customers: models)
                }
        }
    }
    
    func getCustomerWith(id: String, callback: @escaping (Customer)->()) {
        db.collection("customers").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                if var model = Customer(initDictionary: document.data()!) {
                    model.id = document.documentID
                    callback(model)
                } else {
                      preconditionFailure("Unable to initialize type \(Product.self) with dictionary \(document.data())")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //MARK: Products
    func getCustomersProductsWith(id: String) {
        db.collection("customers/\(id)/products")
            .addSnapshotListener { querySnapshot, error in
                guard (querySnapshot?.documents) != nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let models = querySnapshot!.documents.map { (document) -> Product in
                    if var model = Product(initDictionary: document.data()) {
                        model.id = document.documentID
                        return model
                    } else {
                          preconditionFailure("Unable to initialize type \(Product.self) with dictionary \(document.data())")
                    }
                }
                DispatchQueue.main.async {
                    delegate?.didCustomersProductsRetrieved(products: models)
                }
        }
    }
    
    //MARK: Worksheets
    func getCustomersWorksheetsWith(id: String, callback: @escaping ([Worksheet]) -> ()) {
        db.collection("customers/\(id)/worksheets").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //print("\(document.documentID) => \(document.data())")
                let models = snapshot!.documents.map { (document) -> Worksheet in
                    if var model = Worksheet(initDictionary: document.data()) {
                        model.id = document.documentID
                        
                        /*Customer
                        getCustomerWith(id: model.customerId, callback: { (customer) in
                            model.customer = customer
                        })
                        */
                        //Product
                        return model
                    } else {
                          preconditionFailure("Unable to initialize type \(Product.self) with dictionary \(document.data())")
                    }
                }
                
                let group = DispatchGroup()
                for var model in models {
                    group.enter()
                    getCustomerWith(id: model.customerId, callback: { (customer) in
                        model.customer = customer
                        group.leave()
                    })
                    //getProducts()
                }
                group.notify(queue: .main, execute: {
                    callback(models)
                })
                print("asd_1")
            }
        }
    }
    
}
