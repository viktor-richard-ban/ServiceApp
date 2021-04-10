//
//  CustomerSelectorTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 08..
//

import UIKit
import Firebase

protocol CustomerSelectorDelegate {
    func customerSelected(customer: Customer)
}

class CustomerSelectorTableViewController: UITableViewController {
    
    var customers: [Customer] = []
    var selectedCustomer = 0
    
    var delegate : CustomerSelectorDelegate?
    var api = ServiceAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: "ReusableCustomerCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        api.getFirstTenCustomers() { customers in
            self.customers = customers
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCustomerCell", for: indexPath) as! CustomerTableViewCell
        cell.nameLabel.text = customers[indexPath.row].personalData.name
        cell.cityLabel.text = customers[indexPath.row].personalData.address?.city
        cell.lastActvityLabel.text = customers[indexPath.row].lastActivityString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.customerSelected(customer: customers[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    
}
