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
    //var types: [String]
    var isChecked: Bool = false
    var voteCount: Int
    let inviter: User
    
    
    init(name: String, vicinity: String, types: [String]) {
        self.name = name
        self.vicinity = vicinity
        self.voteCount = 0
        self.inviter = User.current
        //self.types = types
        
        super.init()
    }
}
