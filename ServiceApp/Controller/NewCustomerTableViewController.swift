//
//  NewCustomerTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 26..
//

import UIKit
import Firebase

class NewCustomerTableViewController: UITableViewController {
    
    let db = Firestore.firestore()

    var customer : Customer? = nil
    var delegate : CustomerViewController? = nil
    
    // Customer type
    @IBOutlet weak var customerTypeSelector: UISegmentedControl!
    
    //Personal datas
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerTaxTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    
    // Cells
    @IBOutlet weak var customerTaxCell: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerTaxCell.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mentés", style: .plain, target: self, action: #selector(doneClicked))
        
    }
    
    @IBAction func customerTypeClicked(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            customerTaxCell.isHidden = true
        }else if(sender.selectedSegmentIndex == 1 ) {
            customerTaxCell.isHidden = false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCustomer" {
            if let destination = segue.destination as? CustomerViewController {
                let customerTax = (customerTaxTextField.text=="") ? nil : "\(String(describing: customerTaxTextField.text!))"
                self.customer = Customer(id: nil, personalDatas: Datas(
                                        address: Address(city: cityTextField.text ?? "Default",
                                                         street: streetTextField.text ?? "Default",
                                                         postcode: postCodeTextField.text ?? "Default"),
                                        email: emailTextField.text ?? "Default",
                                        name: customerNameTextField.text ?? "Default",
                                            phone: PhoneTextField.text ?? "Default",
                                            tax: customerTax
                    )
                )
                
                createCustomer(customer: self.customer!)
                destination.customer = self.customer
                self.delegate = destination
                
            }
        }
    }
    
    func createCustomer(customer : Customer) {
        let docData : [String: Any]
        if customer.personalDatas.tax != nil {
            docData = [
                "personalDatas": [
                    "address":[
                        "city": customer.personalDatas.address.city,
                        "postcode": customer.personalDatas.address.postcode,
                        "street": customer.personalDatas.address.street
                    ],
                    "email": customer.personalDatas.email,
                    "name": customer.personalDatas.name,
                    "phone": customer.personalDatas.phone,
                    "tax": customer.personalDatas.tax!
                ]
            ]
        } else {
            docData = [
                "personalDatas": [
                    "address":[
                        "city": customer.personalDatas.address.city,
                        "postcode": customer.personalDatas.address.postcode,
                        "street": customer.personalDatas.address.street
                    ],
                    "email": customer.personalDatas.email,
                    "name": customer.personalDatas.name,
                    "phone": customer.personalDatas.phone
                ]
            ]
        }
        
        // Save data
        var ref: DocumentReference? = nil
        ref = db.collection("customers").addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                if let id = ref?.documentID {
                    self.customer?.id = id
                    // FIXME: Add id to destination
                    self.delegate?.updateCustomerId(customerId: self.customer?.id ?? "Default")
                }
                
            }
        }
    }
    
    @objc func doneClicked(){
        if customerNameTextField.text == "" ||
            postCodeTextField.text == "" ||
            cityTextField.text == "" ||
            streetTextField.text == "" ||
            emailTextField.text == "" ||
            PhoneTextField.text == "" ||
            (customerTypeSelector.selectedSegmentIndex == 1 && customerTaxTextField.text==""){
                let alert = UIAlertController(title: "Hiba", message: "Egy mező sem maradhat üresen", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }else {
            self.performSegue(withIdentifier: "GoToCustomer", sender: self)
            // Remove last item from navigation stack
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers
            navigationArray.remove(at: navigationArray.count - 2)
            self.navigationController?.viewControllers = navigationArray
        }
    }
    
}

protocol CustomerDelegate {
    func updateCustomerId(customerId: String)
}
