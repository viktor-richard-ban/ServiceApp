//
//  CustomerViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 23..
//

import UIKit
import Firebase

class CustomerViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var customer : Customer?
    var products : [Product] = []
    var selectedProductIndex : Int = 0
    var modify = false
    
    var productManager = ProductManager()
    
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var mainCard: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("customer id:\(customer?.id ?? "default")")
        productManager.delegate = self
        productManager.fetchProducts(customerId: customer!.id!)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Szerkesztés", style: .plain, target: self, action: #selector(editButtonClicked))
        
        // Style
        addGradientToView(view: topGradientView)
        
        mainCard.layer.cornerRadius = mainCard.frame.size.height/15
        mainCard.layer.shadowColor = UIColor.black.cgColor
        mainCard.layer.shadowOpacity = 1
        mainCard.layer.shadowOffset = .zero
        mainCard.layer.shadowRadius = 15
        
        topGradientView.layer.shadowColor = UIColor.black.cgColor
        topGradientView.layer.shadowOpacity = 1
        topGradientView.layer.shadowOffset = .zero
        topGradientView.layer.shadowRadius = 15
        
        nameLabel.text = customer?.personalData.name
        taxLabel.text = "Magánszemély"
        addressLabel.text = "\(customer?.personalData.address.postcode ?? "Default") \(customer?.personalData.address.city ?? "Default") \(customer?.personalData.address.street ?? "Default")"
        emailLabel.text = customer?.personalData.email
        phoneLabel.text = customer?.personalData.phone
        
        if let tax = customer?.personalData.tax {
            taxLabel.text = tax
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productCollectionView.reloadData()
        
        nameLabel.text = customer?.personalData.name
        addressLabel.text = "\(customer?.personalData.address.postcode ?? "Default") \(customer?.personalData.address.city ?? "Default") \(customer?.personalData.address.street ?? "Default")"
        emailLabel.text = customer?.personalData.email
        phoneLabel.text = customer?.personalData.phone
    }
    
    func addGradientToView(view: UIView) {
        let gradientLayer = CAGradientLayer()
            
        gradientLayer.colors = [
            UIColor.init(red: 52/255, green: 144/255, blue: 200/255, alpha: 1.0).cgColor,
            UIColor.init(red: 58/255, green: 57/255, blue: 100/255, alpha: 1.0).cgColor]
            
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
        gradientLayer.frame = view.bounds
            
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func addProductPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NewProduct", sender: self)
    }
    
    @objc func editButtonClicked () {
        performSegue(withIdentifier: "ModifyCustomer", sender: self)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ModifyCustomer" {
            if let destination = segue.destination as? NewCustomerTableViewController {
                print("Modify customer")
                destination.customer = customer
                destination.delegate = self
                destination.modify = true
            }
        } else if segue.identifier == "NewProduct" {
            if let destination = segue.destination as? NewProductTableViewController {
                if modify {
                    destination.product = products[selectedProductIndex]
                    destination.modify = true
                    modify = false
                }
                destination.delegate = self
                destination.customerId = customer?.id
            }
        }
    }

}

extension CustomerViewController : CustomerDelegate {
    func customerUpdated(customer: Customer) {
        self.customer = customer
        self.nameLabel.text = self.customer?.personalData.name
        self.taxLabel.text = "Magánszemély"
        self.addressLabel.text = "\(self.customer?.personalData.address.postcode ?? "Default") \(self.customer?.personalData.address.city ?? "Default") \(self.customer?.personalData.address.street ?? "Default")"
        self.emailLabel.text = self.customer?.personalData.email
        self.phoneLabel.text = self.customer?.personalData.phone
    }
}

extension CustomerViewController : ProductDelegate {
    func updateProductId(id: String) {
        return
    }
}

extension CustomerViewController : ProductManagerDelegate {
    
    func productsUpdated(products : [Product]) {
        self.products = products
        self.productCollectionView.reloadData()
    }
    
    func productCreated(with: String) {
        return
    }
    
}

extension CustomerViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Product count: \(products.count)")
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        
        // Add datas
        cell.productNameLabel.text = products[indexPath.row].productName
        if let pin = products[indexPath.row].pin {
            cell.pinLabel.text = String(pin)
        } else {
            cell.pinLabel.text = "-"
        }
        cell.serialNumberLabel.text = products[indexPath.row].serialNumber
        cell.productNumberLabel.text = products[indexPath.row].productNumber
        cell.purchaseDate.text = products[indexPath.row].purchaseDate
        
        // Cell style
        cell.layer.cornerRadius = cell.frame.size.height/5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedProductIndex = indexPath.row
        modify = true
        performSegue(withIdentifier: "NewProduct", sender: self)
    }
    
}