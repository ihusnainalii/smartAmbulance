//
//  EmergencyViewController.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/4/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var numberList: UITableView!
    
    // MARK: - variable
    var contacts = [Contacts]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let data1 = Contacts(name: "Hariti Desai", number: "07424 292755", addressValue: "Baker Street, Marylebone")
        contacts.append(data1)
        
        numberList.delegate = self
        numberList.dataSource = self
        
        let nib = UINib(nibName: EmergencyNumberCell.identifire, bundle: nil)
        numberList.register(nib, forCellReuseIdentifier: EmergencyNumberCell.identifire)
        numberList.tableFooterView = UIView(frame: .zero)
        
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
    
}

extension EmergencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = numberList.dequeueReusableCell(withIdentifier: EmergencyNumberCell.identifire, for: indexPath) as! EmergencyNumberCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
