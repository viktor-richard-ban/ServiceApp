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

    @IBOutlet weak var customerTaxCell: UIStackView!
    
    let db = Firestore.firestore()

    var api = ServiceAPI()
    var delegate: CustomerDelegate? = nil
    var customer : Customer? = nil
    var modify : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerTaxCell.isHidden = true
        
        if modify {
            customerNameTextField.text = customer?.personalData.name
            postCodeTextField.text = customer?.personalData.address?.postcode
            cityTextField.text = customer?.personalData.address?.city
            streetTextField.text = customer?.personalData.address?.street
            emailTextField.text = customer?.personalData.email
            phoneTextField.text = customer?.personalData.phone
            if let tax = customer?.personalData.tax {
                customerTaxTextField.text = tax
                customerTaxCell.isHidden = false
                customerTypeSelector.selectedSegmentIndex = 1
            }
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
            let customerName = customerNameTextField.text
            let email = emailTextField.text
            let phone = phoneTextField.text
            
            let tax: String?
            if customerTaxCell.isHidden {
                tax = nil
            } else {
                tax = customerTaxTextField.text
            }
            
            let city = cityTextField.text
            let street = streetTextField.text
            let postCode = postCodeTextField.text
            
            if modify {
                customer = Customer(id: customer!.id, personalData: PersonalData(address: Address(city: city, street: street, postcode: postCode), email: email, name: customerName, phone: phone, tax: tax), lastActivity: Date(), joinDate: customer!.joinDate, products: customer!.products, worksheets: customer!.worksheets)
                
                api.updateCustomer(customer: customer!) { result in
                    if result {
                        let alert = UIAlertController(title: "Sikeres módosítás", message: "Az ügyfél metésre került", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.delegate?.customerUpdated(customer: self.customer!)
                    } else {
                        let alert = UIAlertController(title: "Hiba", message: "Az ügyfél mentése során hiba keletkezett", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                customer = Customer(id: nil, personalData: PersonalData(address: Address(city: city, street: street, postcode: postCode), email: email, name: customerName, phone: phone, tax: tax), lastActivity: Date(), joinDate: Date(), products: [], worksheets: [])
                
                api.createCustomer(customer: customer!) { result in
                    if result {
                        let alert = UIAlertController(title: "Sikeres létrehozás", message: "Az ügyfél metésre került", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.delegate?.customerUpdated(customer: self.customer!)
                    } else {
                        let alert = UIAlertController(title: "Hiba", message: "Az ügyfél mentése során hiba keletkezett", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
}
