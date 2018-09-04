//
//  Ambulance.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/3/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Ambulance: NSObject {
    
    //MARK:- Data Members
    var ambLat: Double!
    var ambLong: Double!
    
    
    //MARK:- Class init
    override init() {
        ambLat = doubleOValue
        ambLong = doubleOValue
    }
    
    //MARK:- Class init to load user details from dict
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        ambLat = latitude
        ambLong = longitude
    }
}
