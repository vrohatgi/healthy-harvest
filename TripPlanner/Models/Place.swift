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
    
    
    init(name: String, vicinity: String, types: [String]) {
        self.name = name
        self.vicinity = vicinity
        //self.types = types
        
        super.init()
    }
}
