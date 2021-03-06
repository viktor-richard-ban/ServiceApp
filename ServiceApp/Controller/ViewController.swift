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
    let db = Firestore.firestore()
    
    var customers: [Customer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: "ReusableCustomerCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        fetchCustomers()
    }

    func fetchCustomers() {
        db.collection("customers").addSnapshotListener { (querySnapshot, err) in
            
            self.customers = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.documentID)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        let customer = try JSONDecoder().decode(Customer.self, from: jsonData)
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
    
}

extension CustomersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCustomerCell", for: indexPath) as! CustomerTableViewCell
        cell.nameLabel.text = customers[indexPath.row].personalDatas.name
        cell.cityLabel.text = customers[indexPath.row].personalDatas.address.city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath.row)
    }

}
