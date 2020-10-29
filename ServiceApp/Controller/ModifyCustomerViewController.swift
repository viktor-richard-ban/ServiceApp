//
//  ModifyTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 29..
//

import UIKit
import Firebase

class ModifyCustomerViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var modify = false
    var customer : Customer? = nil
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mentés", style: .plain, target: self, action: #selector(doneClicked))

        if customer?.personalDatas.tax == nil {
            customerTaxCell.isHidden = true
        }else {
            customerTypeSelector.selectedSegmentIndex = 1
            customerTaxTextField.text = customer?.personalDatas.tax
        }
        
        customerNameTextField.text = customer?.personalDatas.name
        postCodeTextField.text = customer?.personalDatas.address.postcode
        cityTextField.text = customer?.personalDatas.address.city
        streetTextField.text = customer?.personalDatas.address.street
        emailTextField.text = customer?.personalDatas.email
        PhoneTextField.text = customer?.personalDatas.phone
    }
    
    
    @IBAction func customerTypeSelectorClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customerTaxCell.isHidden = true
            break
        case 1:
            customerTaxCell.isHidden = false
            break
        default:
            print("default")
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
            let customerTax = (customerTaxTextField.text=="") ? nil : "\(String(describing: customerTaxTextField.text!))"
            
            let customer = Customer(id: nil, personalDatas: Datas(
                                    address: Address(city: cityTextField.text ?? "Default",
                                                     street: streetTextField.text ?? "Default",
                                                     postcode: postCodeTextField.text ?? "Default"),
                                    email: emailTextField.text ?? "Default",
                                    name: customerNameTextField.text ?? "Default",
                                        phone: PhoneTextField.text ?? "Default",
                                        tax: customerTax
                )
            )
            saveCustomer(customer: customer)
        }
        
    }
    
    func saveCustomer(customer:Customer) {
        //Create document to database
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
        
        //Save to database
        let ref = db.collection("customers").document((self.customer?.id!)!)
        ref.updateData(docData) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        
        // Back to customer view
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
