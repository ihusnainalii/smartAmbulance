//
//  Contacts.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/6/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Contacts: NSObject {
    
    //MARK:- Data Members
    var contactName: String!
    var contactNumber: String!
    var address: String!
    
    
    //MARK:- Class init
    override init() {
        contactName = blankValue
        contactNumber = blankValue
        address = blankValue
    }
    
    //MARK:- Class init to load user details from dict
    convenience init(name: String, number: String, addressValue: String) {
        self.init()
        
        contactName = name
        contactNumber = number
        address = addressValue
        
    }
}

