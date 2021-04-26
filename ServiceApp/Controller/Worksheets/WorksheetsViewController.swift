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
    
    var worksheets : [Worksheet] = []
    
    var selectedIndex : IndexPath?
    
    var serviceAPI = ServiceAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorksheet))
        
        tableView.register(UINib(nibName: "WorksheetCell", bundle: nil), forCellReuseIdentifier: "WorksheetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        serviceAPI.getWorksheets(callback: { worksheets in
            self.worksheets = worksheets
            self.worksheets.sort {
                if $0.status == $1.status {
                    return $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970
                } else {
                    return $0.status > $1.status
                }
            }
            self.tableView.reloadData()
        })
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
                if let index = selectedIndex?.row {
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
        let date = worksheets[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        cell.worksheetDateLabel.text = formatter.string(from: date)
        
        //Customer
        cell.customerNameLabel.text = worksheets[indexPath.row].customer?.personalData.name ?? ""
        cell.customerPlaceLabel.text = worksheets[indexPath.row].customer?.personalData.address?.city ?? ""

        //Product
        cell.productNameLabel.text = worksheets[indexPath.row].product?.name ?? ""
        cell.serialNumberLabel.text = worksheets[indexPath.row].product?.serialNumber ?? ""
        
        //Worksheet status
        cell.statusLabel.text = worksheets[indexPath.row].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "AddWorksheet", sender: self)
    }
    
}

// MARK: Worksheet Extension

extension WorksheetsViewController : NewWorksheetDelegate {
    
    func didUpdateWorksheets() {
        tableView.reloadRows(at: [selectedIndex!], with: .automatic)
        selectedIndex = nil
    }
    
    func didUpdateProduct() {
        return
    }
    
}
