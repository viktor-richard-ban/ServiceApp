//
//  EditLongTextTableViewController.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 11. 01..
//

import UIKit

class EditLongTextTableViewController: UITableViewController {
    
    var delegate : NewWorksheetTableViewController? = nil
    var longText : String = ""
    
    @IBOutlet weak var longTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mentés", style: .done, target: self, action: #selector(doneClicked))
        
        longTextField.text = longText
        longTextField.layer.borderWidth = 1
        longTextField.layer.borderColor = UIColor.gray.cgColor
        longTextField.layer.cornerRadius = 15
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Szerkesztés"
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    @objc func doneClicked() {
        print(longTextField.text ?? "fa")
        
        delegate?.updateLongText(labelName: "errorDescriptionLabel", text: longTextField.text ?? "Hiba")
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - Protocol
protocol LongTextDelegate {
    func updateLongText(labelName : String, text : String)
}
