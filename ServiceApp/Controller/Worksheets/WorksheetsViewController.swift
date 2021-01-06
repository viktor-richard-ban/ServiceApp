//
//  WorksheetsViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 01..
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class WorksheetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var worksheetData : [[String : Any]] = [[:]]
    var productData : [[String : Any]] = [[:]]
    var customerData : [[String : Any]] = [[:]]
    
    var selectedIndex : Int?
    
    // Database
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorksheet))
        
        tableView.register(UINib(nibName: "WorksheetCell", bundle: nil), forCellReuseIdentifier: "WorksheetCell")
        
    }
    
    
    // MARK: Navigation
    
    @objc func addWorksheet() {
        performSegue(withIdentifier: "AddWorksheet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddWorksheet" {
            if let destination = segue.destination as? NewWorksheetTableViewController {
                destination.delegate = self
                if let index = selectedIndex {
                    destination.isModify = true
                    destination.customerData = customerData[index]
                    destination.productData = productData[index]
                    destination.worksheetData = worksheetData[index]
                }
            }
        }
    }

}

// MARK: Tableview Extension

extension WorksheetsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if worksheetData.count == productData.count && customerData.count == productData.count {
            return worksheetData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell", for: indexPath) as! WorksheetTableViewCell
        //Worksheet
        if let date = worksheetData[indexPath.row]["date"] as? Timestamp {
            let sec = date.seconds
            let nanoInSec = Int64(date.nanoseconds / 1000000000)
            let dateInterval = Date(timeIntervalSince1970: TimeInterval(sec+nanoInSec))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd HH:mm"
            cell.worksheetDateLabel.text = formatter.string(from: dateInterval)
            
        }
        if let status = worksheetData[indexPath.row]["status"] as? String {
            cell.statusLabel.text = status
        }
        
        //Product
        if let productName = productData[indexPath.row]["productName"] as? String {
            cell.productNameLabel.text = productName
        }
        if let serialNumber = productData[indexPath.row]["serialNumber"] as? String {
            cell.serialNumberLabel.text = "S/N: \(serialNumber)"
        }
        
        //Customer
        if let personalData = customerData[indexPath.row]["personalDatas"] as? [String:Any]{
            cell.customerNameLabel.text = personalData["name"] as? String
            
            if let address = personalData["address"] as? [String:Any] {
                cell.customerPlaceLabel.text = address["city"] as? String
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "AddWorksheet", sender: self)
    }
    
}

// MARK: Worksheet Extension

extension WorksheetsViewController : NewWorksheetDelegate {
    
    func didUpdateWorksheets() {
        tableView.reloadData()
        selectedIndex = nil
    }
    
    func didUpdateProduct() {
    }
    
}
