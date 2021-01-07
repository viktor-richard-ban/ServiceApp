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
    @IBOutlet weak var purchaseDateTextField: UITextField!
    
    var productType : String = "robotfűnyíró"
    var customerId : String?
    var productId : String?
    
    let db = Firestore.firestore()
    var delegate : CustomerViewController? = nil

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
            let product = Product(
                customerId: customerId ?? nil,
                pin: Int(pinLabel.text!) ?? nil,
                productName: nameLabel.text!,
                productNumber: productNoLabel.text ?? nil,
                productType: productType,
                serialNumber: serialLabel.text ?? nil,
                purchaseDate: purchaseDateTextField.text ?? "-"
            )
            createProduct(product: product)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func createProduct(product: Product) {
        do {
            var ref: DocumentReference? = nil
            ref = try db.collection("products").addDocument(from: product){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    if let id = ref?.documentID {
                        //self.productId? = id
                        //self.delegate?.updateProductId(id: self.productId ?? "Default")
                    }
                    
                }
            }
          }
        catch {
            print(error)
        }
    }
    
}

protocol ProductDelegate {
    func updateProductId(id : String)
}
