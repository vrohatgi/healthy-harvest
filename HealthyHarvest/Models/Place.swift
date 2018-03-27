//
//  Place.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class Place: NSObject {
    
    var name: String
    var vicinity: String
    var isChecked: Bool = false
    let inviter: User
    var votes: Int
    
    init(name: String, vicinity: String, types: [String], votes: Int) {
        self.name = name
        self.vicinity = vicinity
        self.inviter = User.current
        self.votes = votes
        
        super.init()
    }
    
}
