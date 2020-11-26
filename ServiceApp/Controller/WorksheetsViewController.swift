//
//  WorksheetsViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 01..
//

import UIKit
import FirebaseFirestore

class WorksheetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var worksheets : [Worksheet] = []
    
    // Database
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorksheet))
        
        tableView.register(UINib(nibName: "WorksheetCell", bundle: nil), forCellReuseIdentifier: "WorksheetCell")
        
        fetchWorksheets()
    }
    
    func fetchWorksheets() {
        db.collection("worksheets").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            } else {
                self.worksheets = (querySnapshot?.documents.compactMap { queryDocumentSnapshot -> Worksheet? in
                    return try? queryDocumentSnapshot.data(as: Worksheet.self)
                })!
                DispatchQueue.main.async {
                    self.fetchUsers()
                }
            }
        }
    }
    
    func fetchUsers() {
        print("Worksheets \(worksheets.count)")
        for i in 0 ..< worksheets.count {
            print(worksheets[i].customerId)
            let docRef = db.collection("customers").document(worksheets[i].customerId)
            
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()!["personalDatas"]! as! Dictionary<String, Any>
                    let address = data["address"]! as! Dictionary<String, Any>
                    
                    let name = data["name"] as? String
                    worksheets[i].customerName = name!
                    worksheets[i].customerCity = (address["city"] as? String)!
                    print("Name: \(worksheets[i].customerName!)")
                    print(address)
                } else {
                    print("Document does not exist")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
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
            }
        }
    }

}

// MARK: Tableview Extension

extension WorksheetsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        worksheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell", for: indexPath) as! WorksheetTableViewCell
        //Worksheet
        cell.worksheetDateLabel.text = worksheets[indexPath.row].dateString
        cell.statusLabel.text = worksheets[indexPath.row].status
        
        //Product
        //cell.productNameLabel.text =
        //cell.serialNumberLabel.text =
        
        //Customer
        cell.customerNameLabel.text = worksheets[indexPath.row].customerName
        cell.customerPlaceLabel.text = worksheets[indexPath.row].customerCity
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(worksheets[indexPath.row])
    }
    
}

// MARK: Worksheet Extension

extension WorksheetsViewController : NewWorksheetDelegate {
    
    func didUpdateWorksheets() {
        tableView.reloadData()
    }
    
}
