//
//  ModifyProductTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 29..
//

import UIKit
import Firebase
import CodableFirebase

class ModifyProductTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var serialLabel: UITextField!
    @IBOutlet weak var productNoLabel: UITextField!
    @IBOutlet weak var pinLabel: UITextField!
    @IBOutlet weak var pinCell: UITableViewCell!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    
    var productType : String = "robotfűnyíró"
    var customerId : String?
    var product : Product? = nil
    var selectedProductIndex : Int? = nil
    
    let db = Firestore.firestore()
    var delegate : CustomerViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = product?.productName ?? "-"
        serialLabel.text = product?.serialNumber ?? "-"
        productNoLabel.text = product?.productNumber ?? "-"
        if let pinStr = product?.pin {
            pinLabel.text = String(pinStr)
        }else {
            pinLabel.text = "-"
        }
        purchaseDateTextField.text = product?.purchaseDate ?? "-"

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
            let product = Product(
                customerId: customerId ?? nil,
                pin: Int(pinLabel.text!) ?? nil,
                productName: nameLabel.text!,
                productNumber: productNoLabel.text ?? nil,
                productType: productType,
                serialNumber: serialLabel.text ?? nil,
                purchaseDate: purchaseDateTextField.text ?? "-"
            )
            updateProduct(product: product)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProduct(product: Product) {
        self.delegate?.products[selectedProductIndex!] = product
        
        let data = try! FirebaseEncoder().encode(product)
        let _ = db.collection("products").document((self.product?.productId)!).updateData(data as! [AnyHashable : Any])
    }
    
}
