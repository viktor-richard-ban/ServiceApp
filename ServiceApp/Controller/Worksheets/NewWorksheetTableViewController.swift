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
    
    let api = ServiceAPI()
    var delegate : NewWorksheetDelegate? = nil
    
    var isModify = false
    var worksheet : Worksheet!

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
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    var sectionName : String?
    var rowsTitle : [CheckItem]?
    var titleName : String?
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mentés", style: .done, target: self, action: #selector(doneClicked))
        
        if isModify {
            customerNameLabel.text = worksheet.customer?.personalData.name
            cusomterCityLabel.text = worksheet.customer?.personalData.address?.city
            productNameLabel.text = worksheet.product?.name
            productVarriancyLabel.text = worksheet.product?.purchaseDate
            warriantySwitch.isSelected = worksheet.isWarrianty
            reasonLabel.text = worksheet.reason ?? "Szerviz"
            errorDescriptionLabel.text = worksheet.errorDescription ?? "Nincs"
            acceptanceModeLabel.text = worksheet.acceptanceMode ?? "Személyes"
            
            accessoriesLabel.text = ""
            if let accessories = worksheet.accessories {
                for i in 0 ..< accessories.count {
                    accessoriesLabel.text?.append("\(accessories[i])  |  ")
                }
                accessoriesLabel.text?.removeLast(5)
            }
            
            statusLabel.text = worksheet.status
            userIdLabel.text = worksheet.userId
            userNameLabel.text = worksheet.userName
            currentDateLabel.text = formatter.string(from: worksheet.date)
        } else {
            worksheet = Worksheet(id: nil, customerId: "", productId: "", customer: nil, product: nil, reason: "Szerviz", errorDescription: nil, isWarrianty: false, acceptanceMode: "Személyes", accessories: ["Gép"], date: Date(), status: "Nyitott", userId: "123456asd123")
            
            currentDateLabel.text = formatter.string(from: Date())
        }
        
        createChecItems()
        
    }
    
    func createChecItems() {
        for i in 0..<reasons.count {
            if worksheet.reason == reasons[i].title {
                reasons[i].done = true
                break
            } else {
                reasons[i].done = false
            }
        }
        
        for i in 0..<acceptanceModes.count {
            if worksheet.reason == acceptanceModes[i].title {
                acceptanceModes[i].done = true
                break
            } else {
                acceptanceModes[i].done = false
            }
        }
        
        if let worksheetAccessories = worksheet.accessories {
            for i in 0..<accessories.count {
                for j in 0..<worksheetAccessories.count {
                    if worksheetAccessories[j] == accessories[i].title {
                        accessories[i].done = true
                        break
                    } else {
                        accessories[i].done = false
                    }
                }
            }
        }
        
        for i in 0..<statuses.count {
            if worksheet.reason == statuses[i].title {
                statuses[i].done = true
                break
            } else {
                statuses[i].done = false
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
        case 1: // Product
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
        case 2: // Worksheet datas
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
        case 3: // Status
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
        case 4: // UserDatas
            break
        default:
            break
        }
    }
    
    @IBAction func warriantySwitchClicked(_ sender: UISwitch) {
        worksheet.isWarrianty = !worksheet.isWarrianty
    }
    
    // MARK - Done button
    @objc func doneClicked() {
        // Check validation
        if productNameLabel.text == "Nincs kiválasztva" {
            let alert = UIAlertController(title: "Hiba", message: "Termék mező nem maradhat üresen", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Save to database
            if isModify {
                //updateWorksheet()
                api.updateWorksheet(worksheet: worksheet) { result in
                    if result {
                        let alert = UIAlertController(title: "Sikeres módosítás", message: "A munkalap metésre került", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Hiba", message: "A munkalap mentése során hiba keletkezett", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                print(worksheet!)
                //saveWorksheet()
                //worksheetManager.createWorksheet(customerId: worksheet.customerId, worksheet: worksheet.toDictionary())
                api.createWorksheet(worksheet: worksheet) { result in
                    if result {
                        let alert = UIAlertController(title: "Sikeres létrehozás", message: "A munkalap metésre került", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Hiba", message: "A munkalap mentése során hiba keletkezett", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
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
    func customerSelected(customer: Customer) {
        self.customerNameLabel.text = customer.personalData.name
        self.cusomterCityLabel.text = customer.personalData.address?.city
        self.worksheet.customerId = customer.id!
        self.worksheet.customer = customer
    }
}

extension NewWorksheetTableViewController : ProductSelectorDelegate {
    
    func didProductSelected(selectedProduct: Product) {
        self.worksheet.productId = selectedProduct.id!
        self.worksheet.product = selectedProduct
        self.productNameLabel.text = selectedProduct.name
        self.productVarriancyLabel.text = selectedProduct.purchaseDate
    }
    
}
