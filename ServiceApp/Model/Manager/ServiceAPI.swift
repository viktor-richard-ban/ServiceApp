//
//  ServiceAPI.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 03. 14..
//

import Foundation
import Firebase

struct ServiceAPI {
    
    private let db = Firestore.firestore()
    
    //MARK: Create Customer
    func createCustomer(customer: Customer, callback: @escaping (Bool) -> ()) {
        db.collection("customers").addDocument(data: customer.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            } else {
                print("Document successfully written!")
                callback(true)
            }
        }
    }
    
    //MARK: Update Customer
    func updateCustomer(customer: Customer, callback: @escaping (Bool) -> ()) {
        db.collection("customers").document(customer.id!).updateData(customer.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            } else {
                print("Document successfully written!")
                callback(true)
            }
        }
    }
    
    //MARK: Get First Ten Customers
    func getFirstTenCustomers(callback: @escaping ([Customer])->()) {
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
                    callback(models)
                }
        }
    }
    
    //MARK: Get Customer With Id
    func getCustomerWith(id: String, callback: @escaping (Customer)->()) {
        db.collection("customers").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                if var model = Customer(initDictionary: document.data()!) {
                    model.id = document.documentID
                    callback(model)
                } else {
                    preconditionFailure("Unable to initialize type \(Product.self) with dictionary \(document.data() ?? [:])")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //MARK: Get Products With Customer Id
    func getCustomersProductsWith(id: String, callback: @escaping ([Product])->()) {
        db.collection("customers/\(id)/products")
            .addSnapshotListener { querySnapshot, error in
                guard (querySnapshot?.documents) != nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let models = querySnapshot!.documents.map { (document) -> Product in
                    print(document.data())
                    if var model = Product(initDictionary: document.data()) {
                        model.id = document.documentID
                        return model
                    } else {
                          preconditionFailure("Unable to initialize type \(Product.self) with dictionary \(document.data())")
                    }
                }
                DispatchQueue.main.async {
                    callback(models)
                }
        }
    }
    
    //MARK: Get Product With Product Id
    func getCustomersProductWith(customerId: String, productId: String, callback: @escaping (Product)->()) {
        db.collection("customers/\(customerId)/products").document(productId).getDocument { (document, error) in
            if let document = document, document.exists {
                if var model = Product(initDictionary: document.data()!) {
                    model.id = document.documentID
                    callback(model)
                } else {
                    preconditionFailure("Unable to initialize type \(Product.self) with dictionary \(String(describing: document.data()))")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //MARK: Create Product
    func createProduct(product: Product, callback: @escaping (Bool) -> ()) {
        db.collection("customers/\(product.customerId)/products").addDocument(data: product.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            } else {
                print("Document successfully written!")
                callback(true)
            }
        }
    }
    
    //MARK: Update Product
    func updateProduct(product: Product, callback: @escaping (Bool) -> ()) {
        db.collection("customers/\(product.customerId)/products").document(product.id!).updateData(product.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            } else {
                print("Document successfully written!")
                callback(true)
            }
        }
    }
    
    //MARK: Get Worksheets
    func getWorksheets(callback: @escaping ([Worksheet]) -> ()) {
        db.collectionGroup("worksheets").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var models = snapshot!.documents.map { (document) -> Worksheet in
                    if var model = Worksheet(initDictionary: document.data()) {
                        model.id = document.documentID
                        return model
                    } else {
                          preconditionFailure("Unable to initialize type \(Worksheet.self) with dictionary \(document.data())")
                    }
                }
                
                let group = DispatchGroup()
                for index in 0..<models.count {
                    group.enter()
                    getCustomerWith(id: models[index].customerId, callback: { (customer) in
                        models[index].customer = customer
                        group.leave()
                    })
                    group.enter()
                    getCustomersProductWith(customerId: models[index].customerId, productId: models[index].productId, callback: { (product) in
                        models[index].product = product
                        group.leave()
                    })
                }
                group.notify(queue: .main, execute: {
                    callback(models)
                })
            }
        }
    }
    
    //MARK: Get Customers Worksheets
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
            }
        }
    }
    
    //MARK: Create Worksheet
    func createWorksheet(worksheet: Worksheet, callback: @escaping (Bool) -> ()) {
        db.collection("customers/\(worksheet.customerId)/worksheets").addDocument(data: worksheet.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            } else {
                print("Document successfully written!")
                callback(true)
            }
        }
    }
    
    //MARK: Update Worksheet
    func updateWorksheet(worksheet: Worksheet, callback: @escaping (Bool) -> ()) {
        db.collection("customers/\(worksheet.customerId)/worksheets").document(worksheet.id!).updateData(worksheet.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
                callback(false)
            } else {
                print("Document successfully written!")
                callback(true)
            }
        }
    }
    
}
