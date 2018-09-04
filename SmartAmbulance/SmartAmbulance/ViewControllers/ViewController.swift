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
        btnCurrentLocation.layer.borderWidth = 1
        btnCurrentLocation.layer.borderColor = UIColor.black.cgColor
        btnCurrentLocation.layer.cornerRadius = btnCurrentLocation.bounds.height / 2
        btnCurrentLocation.backgroundColor = .white
        
        // bringSubviewToFront
        mapView.bringSubview(toFront: btnCurrentLocation)
        mapView.bringSubview(toFront: btnMpenMenu)
        mapView.bringSubview(toFront: titleLabel)
        
        // Delegate
        mapView.delegate = self
        
        // fetch Data
        SmartManager.shared.getAmbulancesData()
        
        // Notification observer
        let name = Notification.Name(rawValue: "dataRetrive")
        NotificationCenter.default.addObserver(self, selector: #selector(updateAmbulancesOnMap), name: name, object: nil)
        MBProgressHUD.showAdded(to: self.view, animated: trueValue)
        
        
        // Add Swipe gesture
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
    @IBAction func btnCurrentLocationTapped(_ sender: UIButton) {
    }
    @IBAction func btnOpenMenuTapped(_ sender: UIButton) {
        SwipeOpenMenu()
    }
    
    // MARK: - Custom private Functions
    // MARK: - add Swipe to open menu
    @objc private func SwipeOpenMenu() {
        if !SmartManager.shared.isMenuOpen {
            SmartManager.shared.isMenuOpen = true
            self.tabBarController?.tabBar.isHidden = true
            let popOverVC = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            self.addChildViewController(popOverVC)
            let xPosition = self.view.frame.origin.x
            let yPosition = self.view.frame.origin.y
            let width = self.view.bounds.width
            let height = UIScreen.main.bounds.height
            popOverVC.view.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height + 1)
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            popOverVC.sideMenuVIew.layer.add(transition, forKey: kCATransition)
            
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
    }
    
    private func addAmbulancesOnMap() {
        for ambulance in self.ambulances {
            guard let lat = ambulance.ambLat, let long =  ambulance.ambLong else {
                return
            }
            
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
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            //marker.icon = UIImage(named: "ambulance")
            marker.map = mapView
        }
    }
    
    // MARK: - Update kid info
    @objc private func updateAmbulancesOnMap() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        if SmartManager.shared.ambulancesData.count > 0 {
            ambulances = SmartManager.shared.ambulancesData
            self.isShown = false
            mapView.clear()
            addAmbulancesOnMap()
        }else{
            
        }
    }
    
    // MARK: - Update kid info
    @objc private func updateMap() {
        // fetch Data
        SmartManager.shared.ambulancesData.removeAll()
        mapView.clear()
        SmartManager.shared.getAmbulancesData()
    }
    
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.iconView?.tintColor = .blue
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(nextVC, animated: true, completion: nil)
        return true
    }
}

