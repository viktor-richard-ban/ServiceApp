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
    var document : [String : Any] = [:]

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
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        currentDateLabel.text = formatter.string(from: today)
        
        productVarriancyLabel.text = "-"
        cusomterCityLabel.text = "-"
        
        // Add required date to document dictionary
        document["isWarrianty"] = false
        document["status"] = "Nyitott"
        document["userId"] = "-"
        document["date"] = today
        
    }
    
    func saveWorksheet() {
        var ref: DocumentReference? = nil
        ref = db.collection("worksheets").addDocument(data: document) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
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
            document["customerId"] = selectedCustomer?.id
            
            // Save to database
            saveWorksheet()
            
            DispatchQueue.main.async {
                self.delegate?.didUpdateWorksheets()
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
                if let index = document.index(forKey: "accessories") {
                    document.remove(at: index)
                }
            } else {
                document["accessories"] = items
            }
            
            print(document)
        }
    }
    
    
    // CheckboxDelegate
    func updateCheckedRow(labelName : String, selected : Int, rows : [CheckItem]) {
        if labelName == "reasonLabel" {
            reasonLabel.text = reasons[selected].title
            reasons = rows
            
            document["reason"] = reasons[selected].title
            print(document)
        } else if labelName == "acceptance" {
            acceptanceModeLabel.text = acceptanceModes[selected].title
            acceptanceModes = rows
            
            document["acceptanceMode"] = acceptanceModes[selected].title
            print(document)
        } else if labelName == "status" {
            statusLabel.text = statuses[selected].title
            statuses = rows
            
            document["status"] = statuses[selected].title
            print(document)
        }
    }
    
    // LongTextDelegate
    func updateLongText(labelName : String, text : String) {
        
        if labelName == "errorDescriptionLabel" {
            if text != "" {
                errorDescriptionLabel.text = text
                document["errorDescription"] = text
            } else {
                errorDescriptionLabel.text = "Nincs"
                if let index = document.index(forKey: "errorDescription") {
                    document.remove(at: index)
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
        
        document["productId"] = selectedProduct.productId
    }
    
}
