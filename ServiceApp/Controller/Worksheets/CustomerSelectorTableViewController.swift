//
//  CustomerSelectorTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 08..
//

import UIKit
import Firebase

class CustomerSelectorTableViewController: UITableViewController {
    
    var customers: [Customer] = []
    var selectedCustomer = 0
    
    var delegate : NewWorksheetTableViewController?
    var manager = CustomerManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: "ReusableCustomerCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        manager.delegate = self
        manager.fetchCustomers()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCustomerCell", for: indexPath) as! CustomerTableViewCell
        cell.nameLabel.text = customers[indexPath.row].personalData.name
        cell.cityLabel.text = customers[indexPath.row].personalData.address.city
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCustomer = customers[indexPath.row]
        delegate?.customerNameLabel.text = customers[indexPath.row].personalData.name
        delegate?.cusomterCityLabel.text = customers[indexPath.row].personalData.address.city
        delegate?.productVarriancyLabel.text = "-"
        delegate?.productNameLabel.text = "Nincs kiválasztva"
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension CustomerSelectorTableViewController : CustomerManagerDelegate {
    func updateCustomers(customers: [Customer]) {
        self.customers = customers
        tableView.reloadData()
    }
    
    func customerCreated(with: String) {
        return
    }
}
