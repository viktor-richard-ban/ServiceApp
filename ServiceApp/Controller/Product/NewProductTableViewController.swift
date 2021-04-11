//
//  NewProductTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 27..
//

import UIKit
import Firebase

protocol ProductDelegate {
    func updateProductId(id : String)
}

class NewProductTableViewController: UITableViewController {
    
    @IBOutlet weak var productTypeSelector: UISegmentedControl!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var serialLabel: UITextField!
    @IBOutlet weak var productNoLabel: UITextField!
    @IBOutlet weak var pinLabel: UITextField!
    @IBOutlet weak var pinCell: UITableViewCell!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    
    var productType : String = "robotfűnyíró"
    
    let db = Firestore.firestore()
    var delegate : ProductDelegate? = nil
    var api = ServiceAPI()
    
    var modify = false
    var customerId : String?
    var product : Product? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))
                self.navigationItem.rightBarButtonItem = done
        
        if modify {
            title = "Termék szerkesztése"
            loadProduct()
        } else {
            title = "Termék hozzáadása"
        }
    }

    @IBAction func productTypeSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            productType = "robotfűnyíró"
            pinCell.isHidden = false
            break
        case 1:
            productType = "egyéb"
            pinCell.isHidden = true
            break
        default:
            productType = "default"
        }
        print(productType)
    }
    
    @objc func done () {
        // Empty field check
        if nameLabel.text == "" {
            let alert = UIAlertController(title: "Hiba", message: "A megnevezés mező nem maradhat üresen", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if modify {
                product?.name = nameLabel.text!
                product?.productNumber = productNoLabel.text!
                product?.serialNumber = serialLabel.text!
                product?.pin = Int(pinLabel.text!)
                product?.purchaseDate = purchaseDateTextField.text!
                product?.productType = productType
                
                api.updateProduct(product: product!) { (result) in
                    if result {
                        let alert = UIAlertController(title: "Sikeres módosítás", message: "A termék mentésre került", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Hiba", message: "A termék mentése során hiba keletkezett", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else {
                self.product = Product(
                    customerId: customerId!,
                    pin: Int(pinLabel.text!) ?? nil,
                    name: nameLabel.text!,
                    productNumber: productNoLabel.text ?? nil,
                    productType: productType,
                    serialNumber: serialLabel.text ?? nil,
                    purchaseDate: purchaseDateTextField.text ?? "-"
                )
                api.createProduct(product: product!) { (result) in
                    if result {
                        let alert = UIAlertController(title: "Sikeres mentés", message: "A termék mentésre került", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Hiba", message: "A termék mentése során hiba keletkezett", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadProduct() {
        nameLabel.text = product?.name
        serialLabel.text = product?.serialNumber
        productNoLabel.text = product?.productNumber
        if let pin = product?.pin {
            pinLabel.text = String(pin)
        }
        if product?.productType == "robotfűnyíró" {
            productType = "robotfűnyíró"
            pinCell.isHidden = false
        } else {
            productType = "egyéb"
            pinCell.isHidden = true
            productTypeSelector.selectedSegmentIndex = 1
        }
        if let pd = product?.purchaseDate {
            purchaseDateTextField.text = pd
        }
    }
    
}
