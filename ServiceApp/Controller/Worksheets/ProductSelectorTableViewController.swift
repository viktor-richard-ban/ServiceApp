//
//  ProductSelectorTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 11..
//

import UIKit
import Firebase

protocol ProductSelectorDelegate {
    func didProductSelected(selectedProduct: Product)
}

class ProductSelectorTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    let api = ServiceAPI()
    
    var customerId : String? = nil
    var products : [Product] = []
    
    var delegate : ProductSelectorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = customerId {
            api.getCustomersProductsWith(id: id) { products in
                self.products = products
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TwoSide")
        cell.textLabel?.text = products[indexPath.row].name
        cell.detailTextLabel?.text = products[indexPath.row].productNumber
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didProductSelected(selectedProduct: products[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

}
