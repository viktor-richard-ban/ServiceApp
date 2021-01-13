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
    
    var worksheetManager = WorksheetManager()
    var worksheets : [Worksheet] = []
    
    var selectedIndex : Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorksheet))
        
        tableView.register(UINib(nibName: "WorksheetCell", bundle: nil), forCellReuseIdentifier: "WorksheetCell")
        
        worksheetManager.delegate = self
        worksheetManager.fetchWorksheets()
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
                    destination.worksheet = worksheets[index]
                    selectedIndex = nil
                }
            }
        }
    }

}

// MARK: Tableview Extension

extension WorksheetsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.worksheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell", for: indexPath) as! WorksheetTableViewCell
        //Date
        let dateData = worksheets[indexPath.row].date
        let date = Date(timeIntervalSince1970: TimeInterval(dateData/1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        cell.worksheetDateLabel.text = formatter.string(from: date)
        
        //Customer
        cell.customerNameLabel.text = worksheets[indexPath.row].customerName
        cell.customerPlaceLabel.text = worksheets[indexPath.row].customerCity

        //Product
        cell.productNameLabel.text = worksheets[indexPath.row].productName
        cell.serialNumberLabel.text = worksheets[indexPath.row].serialNumber
        
        //Worksheet status
        cell.statusLabel.text = worksheets[indexPath.row].status
        
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
        return
    }
    
}

extension WorksheetsViewController : WorksheetManagerDelegate {
    func worksheetCreated() {
        print("Workseet created")
    }
    
    func worksheetsUpdated(worksheets: [Worksheet]) {
        print("Worksheets updated \(worksheets.count)")
        self.worksheets = worksheets
        tableView.reloadData()
        return
    }
}
