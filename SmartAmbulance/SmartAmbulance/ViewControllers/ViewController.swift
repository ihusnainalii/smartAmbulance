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
import UserNotifications
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: -  IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnMpenMenu: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: -  variables
    let locationManager = CLLocationManager()
    var ambulances = [Ambulance]()
    var isShown = false
    var timer: Timer!
    var userLatitude = 0.0
    var userLongitude = 0.0
    
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
        
        // Add Swipe gesture
        // Open menu
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SwipeOpenMenu))
        recognizer.direction = .right
        self.view.addGestureRecognizer(recognizer)
        
        // Deleagte Confirm for location
        // Ask for Authorisation from the User.
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Requesting for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        // Notification observer
        // When data retrive suvccessfully map ploted all the ambulances
        let name = Notification.Name(rawValue: "dataRetrive")
        NotificationCenter.default.addObserver(self, selector: #selector(updateAmbulancesOnMap), name: name, object: nil)
        MBProgressHUD.showAdded(to: self.view, animated: trueValue)
        
        // Add Timer to get data
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateMap), userInfo: nil, repeats: true)
        
    }
    
    // Get user current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.userLatitude = locValue.latitude
        self.userLongitude = locValue.longitude
        
        // fetch Data
        // get all ambulances from firebase
        SmartManager.shared.getAmbulancesData()
        locationManager.stopUpdatingLocation()
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
    
    // MARK: - Add Ambulances to map
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
            let ambulanceICONImage = UIImage(named: "ambulanceicon")!.withRenderingMode(.alwaysTemplate)
            let markerView = UIImageView(image: ambulanceICONImage)
            marker.iconView = markerView
            marker.iconView?.tintColor = .black
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
            
            //Check if ambulance is near to user
            generateNotification()
        }
    }
    
    // MARK: - Update kid info
    @objc private func updateMap() {
        
        if self.userLongitude != 0.0 && self.userLatitude != 0.0 {
            
            //Remove all data from array
            SmartManager.shared.ambulancesData.removeAll()
            
            //Remove all markers from map
            mapView.clear()
            
            // fetch Data from firebase db
            SmartManager.shared.getAmbulancesData()
        }
        
    }
    
    
    // MARK: - Calculate distance and generate notification
    private func generateNotification() {
        for ambulance in self.ambulances {
            //get latitude and longitude
            guard let lat = ambulance.ambLat, let long =  ambulance.ambLong else {
                return
            }
            
            let dist  = distance(lat1: lat, lon1: long, lat2: self.userLatitude, lon2: self.userLongitude, unit: "M")
            if Int(dist) < 1 {
                //creating the notification content
                let content = UNMutableNotificationContent()
                
                //adding title, subtitle, body and badge
                content.title = "Hey this is Simplified iOS"
                content.subtitle = "iOS Development is fun"
                content.body = "We are learning about iOS Local Notification"
                content.badge = 1
                
                //getting the notification trigger
                //it will be called after 5 seconds
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                //getting the notification request
                let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().delegate = self
                
                //adding the notification to notification center
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
    
    // MARK: - This function converts decimal degrees to radians
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    
    // MARK: - This function converts radians to decimal degrees
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        } else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    // Display notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
}

extension ViewController: GMSMapViewDelegate {
    
    // Click on each ambulance to get detail 
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(nextVC, animated: true, completion: nil)
        return true
    }
}

