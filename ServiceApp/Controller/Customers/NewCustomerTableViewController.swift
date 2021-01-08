//
//  NewCustomerTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 26..
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

protocol CustomerDelegate {
    func customerUpdated(customer: Customer)
}

class NewCustomerTableViewController: UITableViewController {
    
    let db = Firestore.firestore()

    var customer : Customer? = nil
    var delegate : CustomerDelegate? = nil
    var manager = CustomerManager()
    
    var modify : Bool = false
    
    // Customer type
    @IBOutlet weak var customerTypeSelector: UISegmentedControl!
    
    //Personal datas
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerTaxTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    // Cells
    @IBOutlet weak var customerTaxCell: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        customerTaxCell.isHidden = true
        
        if modify {
            customerNameTextField.text = customer?.personalData.name
            postCodeTextField.text = customer?.personalData.address.postcode
            cityTextField.text = customer?.personalData.address.city
            streetTextField.text = customer?.personalData.address.street
            emailTextField.text = customer?.personalData.email
            phoneTextField.text = customer?.personalData.phone
        }
        
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
                destination.customer = self.customer
            }
        }
    }
    
    
    @objc func doneClicked(){
        if customerNameTextField.text == "" ||
            postCodeTextField.text == "" ||
            cityTextField.text == "" ||
            streetTextField.text == "" ||
            emailTextField.text == "" ||
            phoneTextField.text == "" ||
            (customerTypeSelector.selectedSegmentIndex == 1 && customerTaxTextField.text==""){
                let alert = UIAlertController(title: "Hiba", message: "Egy mező sem maradhat üresen", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }else {
            let customerName = customerNameTextField.text!
            let email = emailTextField.text!
            let phone = phoneTextField.text!
            
            let city = cityTextField.text!
            let street = streetTextField.text!
            let postCode = postCodeTextField.text!
            
            if modify {
                customer?.personalData.name = customerNameTextField.text!
            } else {
                customer = Customer(id: nil, personalData: Datas(address: Address(city: city, street: street, postcode: postCode), email: email, name: customerName, phone: phone, tax: nil), products: [], worksheets: [])
            }
                
            if customerTaxTextField.text != "" {
                customer!.personalData.tax = customerTaxTextField.text!
            }
            
            if let dict = customer?.toDictionary() {
                let customerDict = dict
                
                //customerDict["joinDate"] = Date()
                // TODO: Pass actual date
                if modify {
                    if let id = customer?.id {
                        manager.updateCustomer(id: id, customerData: customerDict)
                        print("Update customer with id")
                    }
                    DispatchQueue.main.async {
                        self.delegate?.customerUpdated(customer: self.customer!)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    manager.createCustomer(customer: customerDict)
                }
                
            }
            
        }
    }
    
}

extension NewCustomerTableViewController : CustomerManagerDelegate {
    func updateCustomers(customers: [Customer]) {
        return
    }
    
    func customerCreated(with: String) {
        customer?.id = with
        
        self.performSegue(withIdentifier: "GoToCustomer", sender: self)
        // Remove last item from navigation stack
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        navigationArray.remove(at: navigationArray.count - 2)
        self.navigationController?.viewControllers = navigationArray
    }
}
