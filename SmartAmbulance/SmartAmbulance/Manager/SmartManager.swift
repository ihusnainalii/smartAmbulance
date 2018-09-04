//
//  SmartManager.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/3/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import FirebaseDatabase
import FirebaseCore
import Firebase
import GoogleMaps

class SmartManager: NSObject{
    
    // MARK: - Shared instance
    static let shared = SmartManager()
    
    // MARK: - Shared Variables
    //APP Delegate
    let appDelegate:AppDelegate!
    let ambulancesData = [Ambulance]()
    
    // MARK: -  Variables
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    
    
    // override initlizer
    override init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Shared methods
    // MARK: -  get data from firebase
    func getAmbulancesData() {
        ref = Database.database().reference()
        handle = ref.observe(.value, with: { (ambulances) in
            for ambulance in ambulances.children {
                print(ambulance)
            }
        })
        
        
    }
    
}

