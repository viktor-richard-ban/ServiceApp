//
//  WorksheetCollectionViewCell.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 04. 12..
//

import UIKit

class WorksheetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var accessoriesLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        purchaseDateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
}
