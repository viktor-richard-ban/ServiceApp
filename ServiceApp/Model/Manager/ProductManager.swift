//
//  ProductManager.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2021. 01. 07..
//

import Foundation
import Firebase

protocol ProductManagerDelegate {
    func productsUpdated(products : [ProductTmp])
    func productCreated(with: String)
}

struct ProductManager {
    
    let db = Firestore.firestore()
    var delegate : ProductManagerDelegate?
    
    func fetchProducts(customerId: String) {
        db.collection("customers/\(customerId)/products").addSnapshotListener { (querySnapshot, err) in
            
            var products : [ProductTmp] = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var product = try JSONDecoder().decode(ProductTmp.self, from: jsonData)
                        product.productId = document.documentID
                        products.append(product)
                    } catch {
                        print("Error: \(error)")
                    }
                }
                DispatchQueue.main.async {
                    delegate?.productsUpdated(products: products)
                }
            }
        }
    }
    
    func createProduct(customerId: String, product : [String : Any]) {
        var ref: DocumentReference? = nil
        ref = db.collection("customers/\(customerId)/products").addDocument(data: product) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            DispatchQueue.main.async {
                delegate?.productCreated(with: ref!.documentID)
            }
        }
    }
    
    func updateProduct(customerId: String, productId: String, productData : [String : Any]) {
        db.collection("customers/\(customerId)/products").document(productId).setData(productData) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("id: \(productId)\ndata: \(productData)")
                print("Document successfully updated")
            }
        }
    }
    
}
