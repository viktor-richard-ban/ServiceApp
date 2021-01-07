//
//  ProductManager.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2021. 01. 07..
//

import Foundation
import Firebase

protocol ProductManagerDelegate {
    func updateProducts(products : [Product])
    func productCreated(with: String)
}

struct ProductManager {
    
    let db = Firestore.firestore()
    var delegate : ProductManagerDelegate?
    
    func fetchProducts(customerId: String) {
        db.collection("customers/\(customerId)/products").addSnapshotListener { (querySnapshot, err) in
            
            var products : [Product] = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var product = try JSONDecoder().decode(Product.self, from: jsonData)
                        product.productId = document.documentID
                        products.append(product)
                    } catch {
                        print("Error: \(error)")
                    }
                }
                DispatchQueue.main.async {
                    delegate?.updateProducts(products: products)
                    print(products)
                }
            }
        }
    }
    
}
