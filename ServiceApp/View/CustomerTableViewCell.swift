//
//  CustomerTableViewCell.swift
//  ServiceApp
//
//  Created by Viktor Bán on 2020. 10. 23..
//

import UIKit

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastActvityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackground.layer.cornerRadius = cellBackground.frame.size.height/10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
