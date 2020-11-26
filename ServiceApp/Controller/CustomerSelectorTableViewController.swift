//
//  CustomerSelectorTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 08..
//

import UIKit
import Firebase

class CustomerSelectorTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var customers: [Customer] = []
    var selectedCustomer = 0
    
    var delegate : NewWorksheetTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("asdasdasdasdasdasdasd")
        
        self.tableView.register(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: "ReusableCustomerCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        fetchCustomers()
    }
    
    func fetchCustomers() {
        db.collection("customers").addSnapshotListener { (querySnapshot, err) in
            
            self.customers = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var customer = try JSONDecoder().decode(Customer.self, from: jsonData)
                        customer.id = document.documentID
                        self.customers.append(customer)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCustomerCell", for: indexPath) as! CustomerTableViewCell
        cell.nameLabel.text = customers[indexPath.row].personalDatas.name
        cell.cityLabel.text = customers[indexPath.row].personalDatas.address.city
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCustomer = customers[indexPath.row]
        delegate?.customerNameLabel.text = customers[indexPath.row].personalDatas.name
        delegate?.cusomterCityLabel.text = customers[indexPath.row].personalDatas.address.city
        delegate?.productVarriancyLabel.text = "-"
        delegate?.productNameLabel.text = "Nincs kiválasztva"
        navigationController?.popViewController(animated: true)
    }
    
    
}
