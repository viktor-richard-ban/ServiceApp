//
//  NewWorksheetTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 01..
//

import UIKit

protocol NewWorksheetDelegate {
    func didUpdateWorksheets()
}

class NewWorksheetTableViewController: UITableViewController {
    
    var delegate : NewWorksheetDelegate? = nil
    var worksheetManager = WorksheetManager()
    
    var isModify = false
    var worksheet : Worksheet!
    var selectedCustomer : CustomerTmp? = nil

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
    
    //Personal Data
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var cusomterCityLabel: UILabel!
    
    // Product Data
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productVarriancyLabel: UILabel!
    
    // Worksheet Data
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
        
        worksheetManager.delegate = self
        /*
        if isModify {
            print(worksheet)
            
            customerNameLabel.text = worksheet.customerName
            cusomterCityLabel.text = worksheet.customerCity
            productNameLabel.text = worksheet.productName
            productVarriancyLabel.text = worksheet.purchaseDateString
            
            if worksheet.customerId != "" {
                warriantySwitch.isSelected = worksheet.isWarrianty
                if let reason = worksheet.reason {
                    reasonLabel.text = reason
                }
                errorDescriptionLabel.text = worksheet.errorDescription
                acceptanceModeLabel.text = worksheet.acceptanceMode
                accessoriesLabel.text = ""
                if let accessories = worksheet.accessories {
                    for i in 0 ..< accessories.count {
                        accessoriesLabel.text?.append("\(accessories[i])  |  ")
                    }
                    accessoriesLabel.text?.removeLast(5)
                }
                statusLabel.text = worksheet.status
                currentDateLabel.text = worksheet.dateString
            }
        } else {
            worksheet.date = Int(Date().timeIntervalSince1970*1000)
            
            productVarriancyLabel?.text = "-"
            cusomterCityLabel?.text = "-"
        }
        */
        
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
        worksheet.isWarrianty = !worksheet.isWarrianty
    }
    
    // MARK - Objc
    @objc func doneClicked() {
        // Save data to database
        if productNameLabel.text == "Nincs kiválasztva" {
            let alert = UIAlertController(title: "Hiba", message: "Termék mező nem maradhat üresen", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Save to database
            if isModify {
                //updateWorksheet()
            } else {
                //saveWorksheet()
                //worksheetManager.createWorksheet(customerId: worksheet.customerId, worksheet: worksheet.toDictionary())
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
                destination.customerId = worksheet.customerId
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
                worksheet.accessories = []
            } else {
                worksheet.accessories = items
            }
            
        }
    }
    
    
    // CheckboxDelegate
    func updateCheckedRow(labelName : String, selected : Int, rows : [CheckItem]) {
        if labelName == "reasonLabel" {
            reasonLabel.text = reasons[selected].title
            reasons = rows
            
            worksheet.reason = reasons[selected].title
        } else if labelName == "acceptance" {
            acceptanceModeLabel.text = acceptanceModes[selected].title
            acceptanceModes = rows
            
            worksheet.acceptanceMode = acceptanceModes[selected].title
        } else if labelName == "status" {
            statusLabel.text = statuses[selected].title
            statuses = rows
            
            worksheet.status = statuses[selected].title
        }
    }
    
    // LongTextDelegate
    func updateLongText(labelName : String, text : String) {
        
        if labelName == "errorDescriptionLabel" {
            if text != "" {
                errorDescriptionLabel.text = text
                worksheet.errorDescription = text
            } else {
                errorDescriptionLabel.text = "Nincs"
                worksheet.errorDescription = "Nincs megadva"
            }
        } else {
            errorDescriptionLabel.text = "Hiba"
        }
    }
    
}

extension NewWorksheetTableViewController : CustomerSelectorDelegate {
    func customerSelected(customer: CustomerTmp) {
        self.customerNameLabel.text = customer.personalData.name
        //self.cusomterCityLabel.text = customer.personalData.address.city
        self.worksheet.customerId = customer.id!
        //self.worksheet.customerName = customer.personalData.name
        //self.worksheet.customerCity = customer.personalData.address.city
    }
}

extension NewWorksheetTableViewController : ProductSelectorDelegate {
    
    func didProductSelected(selectedProduct: ProductTmp) {
        self.worksheet.productId = selectedProduct.productId!
        //self.worksheet.serialNumber = selectedProduct.serialNumber
        //self.worksheet.productName = selectedProduct.productName
        self.productNameLabel.text = selectedProduct.productName
        self.productVarriancyLabel.text = selectedProduct.purchaseDate
    }
    
}

extension NewWorksheetTableViewController : WorksheetManagerDelegate {
    func worksheetsUpdated(worksheets: [Worksheet]) {
        return
    }
    
    func worksheetCreated() {
        // TODO: Send email to customer
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
