//
//  NewWorksheetTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 01..
//

import UIKit
import FirebaseFirestore

protocol NewWorksheetDelegate {
    func didUpdateWorksheets()
}

class NewWorksheetTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var delegate : NewWorksheetDelegate? = nil
    
    var selectedCustomer : Customer?
    
    var isModify = false
    
    var worksheetData : [String : Any] = [:]
    var productData : [String : Any] = [:]
    var customerData : [String : Any] = [:]

    var reasons = [
        CheckItem(title: "Szerviz", done: true),
        CheckItem(title: "Éves karbantartás", done: false)
    ]
    var acceptanceModes = [
        CheckItem(title: "Személyes", done: true),
        CheckItem(title: "Utánvét", done: false),
        CheckItem(title: "Helyszíni", done: false)
    ]
    var accessories = [
        CheckItem(title: "Gép", done: true),
        CheckItem(title: "Dokkoló", done: false),
        CheckItem(title: "Töltőkábel", done: false),
        CheckItem(title: "Adapter", done: false)
    ]
    
    var statuses = [
        CheckItem(title: "Nyitott", done: true),
        CheckItem(title: "Lezárt", done: false)
    ]
    
    //Personal Datas
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var cusomterCityLabel: UILabel!
    
    // Product Datas
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productVarriancyLabel: UILabel!
    
    // Worksheet Datas
    @IBOutlet weak var warriantySwitch: UISwitch!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var acceptanceModeLabel: UILabel!
    @IBOutlet weak var accessoriesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    var sectionName : String?
    var rowsTitle : [CheckItem]?
    var titleName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mentés", style: .done, target: self, action: #selector(doneClicked))
        
        if isModify {
            productNameLabel.text = productData["productName"] as? String
            productVarriancyLabel.text = productData["purchaseDate"] as? String
            if let personalData = customerData["personalDatas"] as? [String:Any] {
                customerNameLabel.text = personalData["name"] as? String
                
                if let address = personalData["address"] as? [String:Any] {
                    cusomterCityLabel.text = address["city"] as? String
                }
            }
            if !worksheetData.isEmpty {
                print("GARANCIAAAA")
                if let warrianty = worksheetData["isWarrianty"] as? Bool {
                    warriantySwitch.isOn = warrianty
                    print("GARANCIAAAA")
                }
                if let reason = worksheetData["reason"] as? String {
                    reasonLabel.text = reason
                }
                if let errorDescription = worksheetData["errorDescription"] as? String {
                    errorDescriptionLabel.text = errorDescription
                }
                if let acceptanceMode = worksheetData["acceptanceMode"] as? String {
                    acceptanceModeLabel.text = acceptanceMode
                }
                // TODO: Accessories
                if let status = worksheetData["status"] as? String {
                    statusLabel.text = status
                }
            }
            
        } else {
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd HH:mm"
            currentDateLabel.text = formatter.string(from: today)
            
            productVarriancyLabel.text = "-"
            cusomterCityLabel.text = "-"
            
            // Add required date to document dictionary
            worksheetData["isWarrianty"] = false
            worksheetData["status"] = "Nyitott"
            worksheetData["userId"] = "-"
            worksheetData["date"] = today
        }
        
    }
    
    func saveWorksheet() {
        var ref: DocumentReference? = nil
        ref = db.collection("worksheets").addDocument(data: worksheetData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func updateWorksheet() {
        if let id = worksheetData["id"] as? String {
            if let index = worksheetData.index(forKey: "id") {
                worksheetData.remove(at: index)
            }
            db.collection("worksheets").document(id).updateData(worksheetData) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // Customer selector
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "CustomerSelector", sender: self)
            default:
                break
            }
            break
        case 1: // Billing datas
            break
        case 2: // Product
            switch indexPath.row {
            case 0: // Product selector
                if customerNameLabel.text == "Nincs kiválasztva" {
                    let alert = UIAlertController(title: "Hiba", message: "Nincs kiválasztva ügyfél", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    performSegue(withIdentifier: "ProductSelector", sender: self)
                }
                break
            default:
                break
            }
            break
        case 3: // Worksheet datas
            switch indexPath.row {
            case 0:
                titleName = "reasonLabel"
                sectionName = "Indok"
                rowsTitle = reasons
                performSegue(withIdentifier: "EditCheck", sender: self)
                break
            case 1:
                performSegue(withIdentifier: "LongTextEdit", sender: self)
                break
            case 2: // Acceptance Mode
                titleName = "acceptance"
                sectionName = "Átvétel módja"
                rowsTitle = acceptanceModes
                performSegue(withIdentifier: "EditCheck", sender: self)
                break
            case 3: // Accessories
                titleName = "accessories"
                sectionName = "Tartozékok"
                rowsTitle = accessories
                performSegue(withIdentifier: "MultipleEditCheck", sender: self)
                break
            default:
                break
            }
        case 4: // Status
            switch indexPath.row {
            case 0:
                titleName = "status"
                sectionName = "Státusz"
                rowsTitle = statuses
                performSegue(withIdentifier: "EditCheck", sender: self)
                break
            default:
                break
            }
        case 5: // UserDatas
            break
        default:
            break
        }
    }
    
    @IBAction func warriantySwitchClicked(_ sender: UISwitch) {
        if let warrianty = worksheetData["isWarrianty"] as? Bool {
            worksheetData["isWarrianty"] = !warrianty
        }
    }
    
    // MARK - Objc
    @objc func doneClicked() {
        // TODO: Send email to customer
        
        // Save data to database
        if productNameLabel.text == "Nincs kiválasztva" {
            let alert = UIAlertController(title: "Hiba", message: "Termék mező nem maradhat üresen", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Create Worksheet model
            worksheetData["customerId"] = selectedCustomer?.id
            
            // Save to database
            if isModify {
                updateWorksheet()
            } else {
                saveWorksheet()
            }
        
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LongTextEdit" {
            if let destination = segue.destination as? EditLongTextTableViewController {
                destination.delegate = self
                if errorDescriptionLabel.text != "" {
                    destination.longText = errorDescriptionLabel.text!
                }
            }
        } else if segue.identifier == "EditCheck" {
            if let destination = segue.destination as? EditCheckTableViewController {
                destination.delegate = self
                destination.titleLabel = titleName!
                destination.rows = rowsTitle
                destination.sectionName = sectionName
            }
        } else if segue.identifier == "MultipleEditCheck"{
            if let destination = segue.destination as? MultipleEditCheckTableViewController {
                destination.delegate = self
                destination.titleLabel = titleName!
                destination.rows = rowsTitle
                destination.sectionName = sectionName
            }
        } else if segue.identifier == "CustomerSelector" {
            if let destination = segue.destination as? CustomerSelectorTableViewController {
                destination.delegate = self
            }
        } else if segue.identifier == "ProductSelector" {
            if let destination = segue.destination as? ProductSelectorTableViewController {
                destination.delegate = self
                destination.customer = selectedCustomer
                destination.customerData = customerData
            }
        }
    }

}


extension NewWorksheetTableViewController : LongTextDelegate, CheckBoxDelegate, MultipleCheckBoxDelegate {
    
    // MultipleCheckedDelegate
    func updateMultipleCheckedRows(labelName: String, rows: [CheckItem]) {
        if labelName == "accessories" {
            var items : [String] = []
            var labelText = ""
            for i in rows {
                if i.done {
                    labelText.append(i.title)
                    items.append(i.title)
                    labelText.append(" | ")
                }
            }
            if labelText != "" {
                labelText.removeLast(3)
            }
            accessoriesLabel.text = labelText
            accessories = rows
            if labelText == "" {
                if let index = worksheetData.index(forKey: "accessories") {
                    worksheetData.remove(at: index)
                }
            } else {
                worksheetData["accessories"] = items
            }
            
            print(worksheetData)
        }
    }
    
    
    // CheckboxDelegate
    func updateCheckedRow(labelName : String, selected : Int, rows : [CheckItem]) {
        if labelName == "reasonLabel" {
            reasonLabel.text = reasons[selected].title
            reasons = rows
            
            worksheetData["reason"] = reasons[selected].title
            print(worksheetData)
        } else if labelName == "acceptance" {
            acceptanceModeLabel.text = acceptanceModes[selected].title
            acceptanceModes = rows
            
            worksheetData["acceptanceMode"] = acceptanceModes[selected].title
            print(worksheetData)
        } else if labelName == "status" {
            statusLabel.text = statuses[selected].title
            statuses = rows
            
            worksheetData["status"] = statuses[selected].title
            print(worksheetData)
        }
    }
    
    // LongTextDelegate
    func updateLongText(labelName : String, text : String) {
        
        if labelName == "errorDescriptionLabel" {
            if text != "" {
                errorDescriptionLabel.text = text
                worksheetData["errorDescription"] = text
            } else {
                errorDescriptionLabel.text = "Nincs"
                if let index = worksheetData.index(forKey: "errorDescription") {
                    worksheetData.remove(at: index)
                }
            }
        } else {
            errorDescriptionLabel.text = "Hiba"
        }
    }
    
}

extension NewWorksheetTableViewController : ProductSelectorDelegate {
    
    func didProductSelected(selectedProduct: Product) {
        productNameLabel.text = selectedProduct.productName
        productVarriancyLabel.text = selectedProduct.purchaseDate
        
        worksheetData["productId"] = selectedProduct.productId
    }
    
}
