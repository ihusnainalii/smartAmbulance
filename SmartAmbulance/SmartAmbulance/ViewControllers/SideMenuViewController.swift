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
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sideMenuTable: UITableView!
    @IBOutlet weak var sideMenuWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var menuItems = [SideMenu]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setup view
        // Set menu width
        let width = UIScreen.main.bounds.width / 4
        
        // Divide the screen width into 4 portions and give width of 2 portions to menu
        sideMenuWidthConstraint.constant = width * 3
        
        // Confirm delegates
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        sideMenuTable.separatorColor = .clear
        
        // Register Nib for tableView
        let nib = UINib(nibName: SideMenuCell.cellIdentifire, bundle: nil)
        sideMenuTable.register(nib, forCellReuseIdentifier: SideMenuCell.cellIdentifire)
        
        //Add Swipe gesture
        //Close menu
        let swipeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SwipeCloseMenu))
        swipeRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeRecognizer)
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SwipeCloseMenu))
        self.backgroundView.addGestureRecognizer(tapRecognizer)
        
        //menu items
        //add these items to side menu
        let menuItemData1 = SideMenu(imageName: "emergency", labelName: "Emergency Numbers")
        let menuItemData2 = SideMenu(imageName: "about", labelName: "About Us")
        menuItems.append(menuItemData1)
        menuItems.append(menuItemData2)
    }
    
    // Touch count / recognizer
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //close menu if it is not a sideMenuVIew
            if touch.view != sideMenuVIew {
                SwipeCloseMenu()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    

    // MARK: - didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Functions
    // MARK: - SwipeCloseMenu
    @objc func SwipeCloseMenu() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            // Close menu
            self.sideMenuWidthConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            if success {
                // Remove from view and get home view again
                self.view.removeFromSuperview()
                SmartManager.shared.isMenuOpen = false
            }
        }
    }

    // MARK: - IBAction
    // MARK: - btn Version Tapped
    @IBAction func btnVersionTapped(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VersionViewController") as! VersionViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Number of items in menu
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    //Data in each menu item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTable.dequeueReusableCell(withIdentifier: SideMenuCell.cellIdentifire, for: indexPath) as! SideMenuCell
        cell.menu = menuItems[indexPath.row]
        cell.displayData()
        return cell
    }
    
    //height of header which is "Smart Ambulance"
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    //Give header to tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let HeaderView = Bundle.main.loadNibNamed(HeaderSection.cellIdentifire, owner: self, options: nil)![0] as! HeaderSection
        return HeaderView
    }
    
    //height each menu item
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //Click on each menu item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //Handling of Emergency contacts
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EmergencyViewController") as! EmergencyViewController
            self.present(nextVC, animated: true, completion: nil)
        }else if indexPath.row == 1 {
            //Handling of About us
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            self.present(nextVC, animated: true, completion: nil)
        }
    }
}

