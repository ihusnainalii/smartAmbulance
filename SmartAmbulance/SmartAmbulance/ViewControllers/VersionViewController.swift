//
//  VersionViewController.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/4/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var btnRateUs: UIButton!
    
    // MARK: - variable
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Setup view
        btnRateUs.layer.cornerRadius = btnRateUs.bounds.height / 2
        btnRateUs.layer.borderWidth = 1
        btnRateUs.layer.borderColor = UIColor.gray.cgColor
    }
    
    // MARK: - didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBAction
    // MARK: - btn Back Tapped Action
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - btn rate App  Tapped Action
    @IBAction func btnRateUsTapped(_ sender: UIButton) {
        
        //Add here you app id if uploaded to app store
        rateApp(appId: "id959379869") { success in
            print("RateApp \(success)")
        }
    }
    
    
    // MARK: - Custom function
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        
        // optional unwrap 
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
}
