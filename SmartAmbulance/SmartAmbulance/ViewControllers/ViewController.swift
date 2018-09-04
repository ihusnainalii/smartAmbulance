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
import MBProgressHUD

class ViewController: UIViewController {

    // MARK: -  IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnMpenMenu: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: -  variables
    var ambulances = [Ambulance]()
    var isShown = false
    var timer: Timer!
    
    // MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setup view
        // Button Setup
        btnCurrentLocation.layer.borderWidth = 1 // borderr width
        btnCurrentLocation.layer.borderColor = UIColor.black.cgColor // Color to border of button
        btnCurrentLocation.layer.cornerRadius = btnCurrentLocation.bounds.height / 2 // Rounded Button
        btnCurrentLocation.backgroundColor = .white // background color
        
        // bringSubviewToFront
        // As map every time map comes in front of these UI elements
        mapView.bringSubview(toFront: btnCurrentLocation)
        mapView.bringSubview(toFront: btnMpenMenu)
        mapView.bringSubview(toFront: titleLabel)
        
        // Delegate
        mapView.delegate = self
        
        // fetch Data
        // get all ambulances from firebase
        SmartManager.shared.getAmbulancesData()
        
        // Notification observer
        // When data retrive suvccessfully map ploted all the ambulances
        let name = Notification.Name(rawValue: "dataRetrive")
        NotificationCenter.default.addObserver(self, selector: #selector(updateAmbulancesOnMap), name: name, object: nil)
        MBProgressHUD.showAdded(to: self.view, animated: trueValue)
        
        
        // Add Swipe gesture
        // Open menu
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SwipeOpenMenu))
        recognizer.direction = .right
        self.view.addGestureRecognizer(recognizer)
        
        // Add Timer to get data
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateMap), userInfo: nil, repeats: true)
    }

    // MARK: -  didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -  IBAction
    // MARK: -  btn Current Location Tapped
    @IBAction func btnCurrentLocationTapped(_ sender: UIButton) {
    }
    
    // MARK: -  btn Open Menu Tapped
    @IBAction func btnOpenMenuTapped(_ sender: UIButton) {
        SwipeOpenMenu()
    }
    
    // MARK: - Custom private Functions
    // MARK: - add Swipe to open menu
    @objc private func SwipeOpenMenu() {
        if !SmartManager.shared.isMenuOpen {
            SmartManager.shared.isMenuOpen = true
            
            //Add Child view to viewController
            let popOverVC = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            self.addChildViewController(popOverVC)
            let xPosition = self.view.frame.origin.x
            let yPosition = self.view.frame.origin.y
            let width = self.view.bounds.width
            let height = UIScreen.main.bounds.height
            popOverVC.view.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height + 1)
            
            //Transition
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            popOverVC.sideMenuVIew.layer.add(transition, forKey: kCATransition)
            
            //Add Subview
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
    }
    
    private func addAmbulancesOnMap() {
        for ambulance in self.ambulances {
            
            //get latitude and longitude
            guard let lat = ambulance.ambLat, let long =  ambulance.ambLong else {
                return
            }
            
            //Add Camera to amp to focus on first ambulance
            if !isShown {
                UIView.animate(withDuration: 0.5, animations: {
                    
                    // Map Camera
                    let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
                    self.mapView.camera = camera
                    
                }) { (success) in
                    if success {
                        self.isShown = true
                    }
                }
            }
            
            //Add merkers where ambulance is
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            //marker.icon = UIImage(named: "ambulance")
            marker.map = mapView
        }
    }
    
    // MARK: - update Ambulances OnMap
    @objc private func updateAmbulancesOnMap() {
        //Remove loading view
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
        //Check for data to greater then zero
        if SmartManager.shared.ambulancesData.count > 0 {
            
            //Add data to local variable as a copy
            ambulances = SmartManager.shared.ambulancesData
            
            //This check is to focus camera on map for first time
            self.isShown = false
            
            //Remove all markers from map
            mapView.clear()
            
            //Plot markers from map
            addAmbulancesOnMap()
        }
    }
    
    // MARK: - Update kid info
    @objc private func updateMap() {
        
        //Remove all data from array
        SmartManager.shared.ambulancesData.removeAll()
        
        //Remove all markers from map
        mapView.clear()
        
        // fetch Data from firebase db
        SmartManager.shared.getAmbulancesData()
    }
    
}

extension ViewController: GMSMapViewDelegate {
    
    // Click on each ambulance to get detail 
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.iconView?.tintColor = .blue
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(nextVC, animated: true, completion: nil)
        return true
    }
}

