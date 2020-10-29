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
    
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var mainCard: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        print("customer id:\(customer?.id ?? "default")")
        
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Szerkesztés", style: .plain, target: self, action: #selector(editButtonClicked))
        
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
        
        nameLabel.text = customer?.personalDatas.name
        taxLabel.text = "Magánszemély"
        addressLabel.text = "\(customer?.personalDatas.address.postcode ?? "Default") \(customer?.personalDatas.address.city ?? "Default") \(customer?.personalDatas.address.street ?? "Default")"
        emailLabel.text = customer?.personalDatas.email
        phoneLabel.text = customer?.personalDatas.phone
        
        if let tax = customer?.personalDatas.tax {
            taxLabel.text = tax
        }
    
        fetchProducts()
        
    }
    
    func addGradientToView(view: UIView)
    {
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
    
    func fetchProducts() {
        db.collection("products").whereField("customerId", isEqualTo: customer?.id as Any).addSnapshotListener { (querySnapshot, err) in
            
            self.products = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        let product = try JSONDecoder().decode(Product.self, from: jsonData)
                        self.products.append(product)
                    } catch {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func addProductPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NewProduct", sender: self)
    }
    
    
    // MARK: - Navigation
    @objc func editButtonClicked () {
        performSegue(withIdentifier: "ModifyCustomer", sender: self)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ModifyCustomer" {
            if let destination = segue.destination as? ModifyCustomerViewController {
                destination.customer = customer
            }
        } else if segue.identifier == "NewProduct" {
            if let destination = segue.destination as? NewProductTableViewController {
                destination.customerId = customer?.id
            }
        }
    }
    

}

extension CustomerViewController : CustomerDelegate {
    
    func updateCustomerId(customerId: String) {
        self.customer?.id = customerId
    }
    
}

extension CustomerViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(products.count)
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        
        // Add datas
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.pinLabel.text = String(products[indexPath.row].pin!)
        cell.serialNumberLabel.text = products[indexPath.row].serialNumber
        cell.productNumberLabel.text = products[indexPath.row].productNumber
        
        // Cell style
        cell.layer.cornerRadius = cell.frame.size.height/5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(products[indexPath.row].productName)
    }
    
}
