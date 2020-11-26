//
//  ProductSelectorTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 11..
//

import UIKit
import Firebase

class ProductSelectorTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var customer : Customer?
    var products : [Product] = []
    
    var delegate : ProductSelectorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProduct()
    }
    
    func fetchProduct() {
        db.collection("products").whereField("customerId", isEqualTo: customer?.id as Any).addSnapshotListener { (querySnapshot, err) in
            
            self.products = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var product = try JSONDecoder().decode(Product.self, from: jsonData)
                        product.productId = document.documentID
                        self.products.append(product)
                    } catch {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TwoSide")
        cell.textLabel?.text = products[indexPath.row].productName
        cell.detailTextLabel?.text = products[indexPath.row].productNumber
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didProductSelected(selectedProduct: products[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

}

protocol ProductSelectorDelegate {
    func didProductSelected(selectedProduct:Product)
}
