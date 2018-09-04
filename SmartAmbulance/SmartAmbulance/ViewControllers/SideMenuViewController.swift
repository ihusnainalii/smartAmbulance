//
//  SideMenuViewController.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/4/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var sideMenuVIew: UIView!
    @IBOutlet weak var sideMenuTable: UITableView!
    @IBOutlet weak var sideMenuWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setup view
        // Set menu width
        let width = UIScreen.main.bounds.width / 4
        
        // Divide the screen width into 4 portions and give width of 3 portions to menu
        sideMenuWidthConstraint.constant = width * 3
        
        // Confirm delegates
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        
        // Register Nib for tableView
        let nib = UINib(nibName: SideMenuCell.cellIdentifire, bundle: nil)
        sideMenuTable.register(nib, forCellReuseIdentifier: SideMenuCell.cellIdentifire)
        
    }

    // MARK: - didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

}
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTable.dequeueReusableCell(withIdentifier: SideMenuCell.cellIdentifire, for: indexPath) as! SideMenuCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let HeaderView = Bundle.main.loadNibNamed(HeaderSection.cellIdentifire, owner: self, options: nil)![0] as! HeaderSection
        return HeaderView
    }
    
}

