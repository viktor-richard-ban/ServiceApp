//
//  MultipleEditCheckTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 10..
//

import UIKit

class MultipleEditCheckTableViewController: UITableViewController {

    var sectionName : String?
    var rows : [CheckItem]?
    
    var delegate : MultipleCheckBoxDelegate?
    var titleLabel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mentés", style: .done, target: self, action: #selector(doneClicked))
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditCheck", for: indexPath)

        // Configure the cell...
        let item = rows![indexPath.row]
        cell.textLabel!.text = item.title
        
        if item.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rows![indexPath.row].done = !rows![indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    
    // MARK: - Navigation
    @objc func doneClicked() {
        print("Done clicked")
        delegate?.updateMultipleCheckedRows(labelName : titleLabel, rows: rows!)
        self.navigationController?.popViewController(animated: true)
    }

}

protocol MultipleCheckBoxDelegate {
    func updateMultipleCheckedRows(labelName : String, rows: [CheckItem])
}
