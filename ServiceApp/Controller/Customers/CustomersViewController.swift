//
//  ViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 22..
//

import UIKit
import Firebase

class CustomersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var serviceAPI = ServiceAPI()
    var customers: [Customer] = []
    var selectedCustomer = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))
        
        tableView.register(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: "ReusableCustomerCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        serviceAPI.getFirstTenCustomers { (customers) in
            self.customers = customers
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CustomerSegue" {
            if let destination = segue.destination as? CustomerViewController {
                destination.customer = customers[selectedCustomer]
            }
        } else if segue.identifier == "NewCustomer" {
            let _ = segue.destination as? NewCustomerTableViewController
        }
    }
    
    @objc func addClicked(){
        self.performSegue(withIdentifier: "NewCustomer", sender: self)
    }
    
}

extension CustomersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCustomerCell", for: indexPath) as! CustomerTableViewCell
        cell.nameLabel.text = customers[indexPath.row].personalData.name
        cell.cityLabel.text = customers[indexPath.row].personalData.address?.city
        if let city = customers[indexPath.row].personalData.address?.city {
            cell.cityLabel.text = city
        }
        cell.lastActvityLabel.text = customers[indexPath.row].lastActivityString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCustomer = indexPath.row
        self.performSegue(withIdentifier: "CustomerSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor.darkGray
        searchBar.delegate = self
        return searchBar
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(65)
    }

}

extension CustomersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            if searchedText != "" {
                serviceAPI.getCustomerWith(name: searchedText) { [weak self] (customers) in
                    self?.customers = customers
                    self?.tableView.reloadData()
                }
            } else {
                serviceAPI.getFirstTenCustomers { [weak self] (customers) in
                    self?.customers = customers
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = false
    }
}
