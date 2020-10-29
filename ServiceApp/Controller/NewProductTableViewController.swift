//
//  NewProductTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 27..
//

import UIKit
import Firebase

class NewProductTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var serialLabel: UITextField!
    @IBOutlet weak var productNoLabel: UITextField!
    @IBOutlet weak var pinLabel: UITextField!
    @IBOutlet weak var pinCell: UITableViewCell!
    
    var productType : String = "robotfűnyíró"
    var customerId : String?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))
                self.navigationItem.rightBarButtonItem = done
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
            if customerId == nil {
                // FIXME: fetch customer's id
                customerId = "-1"
            }
    
            let product = Product(
                customerId: customerId ?? "-1",
                pin: Int(pinLabel.text!) ?? -1,
                productName: nameLabel.text!,
                productNumber: productNoLabel.text ?? "",
                productType: productType,
                serialNumber: serialLabel.text ?? ""
            )
            createProduct(product: product)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func createProduct(product: Product) {
        // TODO: Create product
        print(product.customerId)
    }
    
}
