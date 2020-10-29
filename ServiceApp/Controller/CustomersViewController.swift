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
    var selectedCustomer = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))
        
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
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var customer = try JSONDecoder().decode(Customer.self, from: jsonData)
                        customer.id = document.documentID
                        print(customer.id!)
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
        cell.nameLabel.text = customers[indexPath.row].personalDatas.name
        cell.cityLabel.text = customers[indexPath.row].personalDatas.address.city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCustomer = indexPath.row
        self.performSegue(withIdentifier: "CustomerSegue", sender: self)
    }

}
