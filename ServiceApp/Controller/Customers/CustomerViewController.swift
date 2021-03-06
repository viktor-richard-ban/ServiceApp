//
//  CustomerViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 23..
//

import UIKit
import Firebase

class CustomerViewController: UIViewController {
    
    var customer : Customer!
    var selectedProductIndex : IndexPath?
    var modify = false
    
    var serviceAPI = ServiceAPI()
    
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var mainCard: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var worksheetCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        addressLabel.text = "\(customer?.personalData.address?.postcode ?? "Default") \(customer?.personalData.address?.city ?? "Default") \(customer?.personalData.address?.street ?? "Default")"
        emailLabel.text = customer?.personalData.email
        phoneLabel.text = customer?.personalData.phone
        
        if let tax = customer?.personalData.tax {
            taxLabel.text = tax
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productCollectionView.reloadData()
        
        serviceAPI.getCustomersProductsWith(id: customer.id!) { products in
            self.customer.products = products
            self.productCollectionView.reloadData()
        }
        serviceAPI.getCustomersWorksheetsWith(id: customer.id!, callback: { worksheets in
            self.customer.worksheets = worksheets
            self.worksheetCollectionView.reloadData()
        })
        
        nameLabel.text = customer?.personalData.name
        addressLabel.text = "\(customer?.personalData.address?.postcode ?? "Default") \(customer?.personalData.address?.city ?? "Default") \(customer?.personalData.address?.street ?? "Default")"
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
    
    @IBAction func addWorksheetPressed(_ sender: UIButton) {
        //TODO: show newWorksheVC
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
                destination.customer = customer
                destination.delegate = self
                destination.modify = true
            }
        } else if segue.identifier == "NewProduct" {
            if let destination = segue.destination as? NewProductTableViewController {
                if modify {
                    if let index = selectedProductIndex?.row, let product = customer?.products[index] {
                        destination.product = product
                        destination.modify = true
                        modify = false
                    }
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
        self.addressLabel.text = "\(self.customer?.personalData.address?.postcode ?? "Default") \(self.customer?.personalData.address?.city ?? "Default") \(self.customer?.personalData.address?.street ?? "Default")"
        self.emailLabel.text = self.customer?.personalData.email
        self.phoneLabel.text = self.customer?.personalData.phone
        if let tax = customer.personalData.tax {
            taxLabel.text = tax
        } else {
            taxLabel.text = "Magánszemély"
        }
    }
}

extension CustomerViewController : ProductDelegate {
    func updateProductId(id: String) {
        return
    }
}

extension CustomerViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.worksheetCollectionView {
            return customer.worksheets.count
        }
        return customer.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
            
            // Add datas
            cell.productNameLabel.text = customer.products[indexPath.row].name
            if let pin = customer.products[indexPath.row].pin {
                cell.pinLabel.text = String(pin)
            } else {
                cell.pinLabel.text = "-"
            }
            cell.serialNumberLabel.text = customer.products[indexPath.row].serialNumber
            cell.productNumberLabel.text = customer.products[indexPath.row].productNumber
            cell.purchaseDate.text = customer.products[indexPath.row].purchaseDate
            
            // Cell style
            cell.layer.cornerRadius = cell.frame.size.height/5
            
            return cell
        } else if collectionView == worksheetCollectionView {
            let cell = worksheetCollectionView.dequeueReusableCell(withReuseIdentifier: "worksheetCell", for: indexPath) as! WorksheetCollectionViewCell
            
            for index in 0..<customer.products.count {
                if customer.worksheets[indexPath.row].productId == customer.products[index].id {
                    customer.worksheets[indexPath.row].product = customer.products[index]
                }
            }
            let worksheet = customer.worksheets[indexPath.row]
            
            cell.productNameLabel.text = worksheet.status
            cell.typeLabel.text = worksheet.reason
            cell.serialNumberLabel.text = worksheet.product?.serialNumber
            cell.accessoriesLabel.text = worksheet.accessoriesString
            cell.purchaseDateLabel.text = worksheet.date.dateStringWith(format: "yyyy.MM.dd")
            
            // Cell style
            cell.layer.cornerRadius = cell.frame.size.height/5
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView {
            self.selectedProductIndex = indexPath
            modify = true
            performSegue(withIdentifier: "NewProduct", sender: self)
        } else if collectionView == worksheetCollectionView {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewWorksheet") as! NewWorksheetTableViewController
            vc.isModify = true
            customer.worksheets[indexPath.row].customer = customer
            vc.worksheet = customer.worksheets[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
