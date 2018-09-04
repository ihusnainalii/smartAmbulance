//
//  SideMenuCell.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/4/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    // MARK: - Cell identifire
    static let cellIdentifire = "SideMenuCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    // MARK: - Variables
    var menu = SideMenu()
    
    
    // MARK: - IBOutlet
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayData() {
        if let image = menu.imageName {
            cellImage.image = UIImage(named: image)
        }
        if let text = menu.labelName {
            cellTextLabel.text = text
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
