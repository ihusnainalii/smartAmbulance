//
//  String+Extension.swift
//  SmartAmbulance
//
//  Created by Husnain on 9/6/18.
//  Copyright © 2018 SmartAmbulance. All rights reserved.
//

import Foundation

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
