//
//  DetailViewController.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/4/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - variable
    var name = ""
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if name != "" {
            nameLabel.text = name
        }else{
            nameLabel.text = "unknown"
        }
    }
    
    // MARK: - didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBAction
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
