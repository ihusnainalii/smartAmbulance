//
//  ViewController.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/3/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import Firebase
import GoogleMaps

class ViewController: UIViewController {

    // MARK: -  IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    
    // MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setup view
        btnCurrentLocation.layer.borderWidth = 1
        btnCurrentLocation.layer.borderColor = UIColor.black.cgColor
        btnCurrentLocation.layer.cornerRadius = btnCurrentLocation.bounds.height / 2
        btnCurrentLocation.backgroundColor = .white
        
        // bringSubviewToFront
        mapView.bringSubview(toFront: btnCurrentLocation)
        
        // fetch Data
        SmartManager.shared.getAmbulancesData()
    }

    // MARK: -  didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -  IBAction
    @IBAction func btnCurrentLocationTapped(_ sender: UIButton) {
    }
    @IBAction func btnMenuTapped(_ sender: UIBarButtonItem) {
        print("menu tapped")
    }
    
}

