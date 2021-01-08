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
    var productManager = ProductManager()
    
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
                product?.productName = nameLabel.text!
                product?.productNumber = productNoLabel.text!
                product?.serialNumber = serialLabel.text!
                product?.pin = Int(pinLabel.text!)
                product?.purchaseDate = purchaseDateTextField.text!
                product?.productType = productType
                productManager.updateProduct(customerId: customerId!, productId: product!.productId!, productData: product!.toDictionary())
            }else {
                self.product = Product(
                    customerId: customerId ?? "nil",
                    pin: Int(pinLabel.text!) ?? nil,
                    productName: nameLabel.text!,
                    productNumber: productNoLabel.text ?? nil,
                    productType: productType,
                    serialNumber: serialLabel.text ?? nil,
                    purchaseDate: purchaseDateTextField.text ?? "-"
                )
                //createProduct(product: product)
                let productDictionary : [String:Any] = product!.toDictionary()
                productManager.createProduct(customerId: customerId!, product: productDictionary)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadProduct() {
        nameLabel.text = product?.productName
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

extension NewProductTableViewController : ProductManagerDelegate {
    func productsUpdated(products: [Product]) {
        return
    }
    
    func productCreated(with: String) {
        navigationController?.popViewController(animated: true)
    }
}
