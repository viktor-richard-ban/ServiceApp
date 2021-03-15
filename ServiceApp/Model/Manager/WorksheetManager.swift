//
//  WorksheetManager.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2021. 01. 06..
//

import Foundation
import Firebase

protocol WorksheetManagerDelegate {
    func worksheetsUpdated(worksheets : [Worksheet])
    func worksheetCreated()
}

struct WorksheetManager {
    
    let db = Firestore.firestore()
    var delegate : WorksheetManagerDelegate? = nil
    
    func fetchWorksheets() {
        db.collectionGroup("worksheets").addSnapshotListener { (querySnapshot, err) in
            
            var worksheets : [Worksheet] = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        var worksheet = try JSONDecoder().decode(Worksheet.self, from: jsonData)
                        //worksheet.worksheetId = document.documentID
                        worksheets.append(worksheet)
                    } catch {
                        print("Error: \(error)")
                    }
                }
                DispatchQueue.main.async {
                    delegate?.worksheetsUpdated(worksheets: worksheets)
                }
            }
        }
    }
    
    func createWorksheet(customerId: String, worksheet : [String : Any]) {
        var ref: DocumentReference? = nil
        ref = db.collection("customers/\(customerId)/worksheets").addDocument(data: worksheet) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            DispatchQueue.main.async {
                delegate?.worksheetCreated()
            }
        }
    }
    
    func updateProduct(customerId: String, worksheetId: String, worksheetData : [String : Any]) {
        db.collection("customers/\(customerId)/worksheets").document(worksheetId).setData(worksheetData) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}
