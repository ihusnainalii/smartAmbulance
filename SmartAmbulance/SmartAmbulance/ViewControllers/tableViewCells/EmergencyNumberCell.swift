//
//  EmergencyNumberCell.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/6/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit

class EmergencyNumberCell: UITableViewCell {

    // MARK: - Identifre
    static let identifire = "EmergencyNumberCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupCell(contact: Contacts){
        if let name = contact.contactName {
            nameLabel.text = name
        }
        
        if let add = contact.address {
            address.text = add
        }
        
        if let number = contact.contactNumber {
            numberLabel.text = number
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
