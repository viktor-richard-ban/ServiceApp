//
//  EditCheckTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 02..
//

import UIKit

class EditCheckTableViewController: UITableViewController {
    
    var sectionName : String?
    var rows : [CheckItem]?
    var selectedIndex = 0
    
    var delegate : CheckBoxDelegate?
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
            selectedIndex = indexPath.row
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rows![selectedIndex].done = !rows![selectedIndex].done
        rows![indexPath.row].done = !rows![indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    
    // MARK: - Navigation
    @objc func doneClicked() {
        print("Done clicked")
        delegate?.updateCheckedRow(labelName : titleLabel, selected: selectedIndex, rows: rows!)
        self.navigationController?.popViewController(animated: true)
    }
    
}

protocol CheckBoxDelegate {
    // TODO: update reason in nreWorksheet
    func updateCheckedRow(labelName: String, selected : Int, rows : [CheckItem])
}
