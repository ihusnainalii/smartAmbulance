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
    var ambulancesData = [Ambulance]()
    var isNotificationSend = [String]()
    
    // MARK: -  Variables
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var isMenuOpen = false
    
    
    // override initlizer
    override init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Shared methods
    // MARK: -  get data from firebase
    func getAmbulancesData() {
        ref = Database.database().reference()
        handle = ref.observe(.value, with: { (ambulances) in
            for ambulance in ambulances.children.allObjects as! [DataSnapshot] {
                let data =  ambulance.value as! String
                let name =  ambulance.key
                let dataValues = data.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
                guard let latitude = Double(dataValues[0]) else {
                    return
                }
                
                guard let longitude = Double(dataValues[1]) else {
                    return
                }
                let ambulanceObject = Ambulance(latitude: latitude, longitude: longitude, nameValue: name)
                self.ambulancesData.append(ambulanceObject)
            }
            
            //Notification center method
            //Broad Cast if user info update
            let name = Notification.Name(rawValue: "dataRetrive")
            NotificationCenter.default.post(name: name, object: nil)
        })
        
        
    }
    
}

