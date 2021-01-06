//
//  ProductCollectionViewCell.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 24..
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var productNumberLabel: UILabel!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var purchaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        purchaseDate.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }

}
