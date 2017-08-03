//
//  EventBuilder.swift
//  TripPlanner
//
//  Created by sumeet rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class EventBuilder: NSObject {
    
    var selectedPlaces: [Place]
    
    override init() {
        self.selectedPlaces = [Place]()
        
        super.init()
    }
    
    func sync(places: [Place]) {
        var x = [Place]()
        for p in places {
            if p.isChecked {
                x.append(p)
            }
        }
        self.selectedPlaces = x
    }
    
    func buildList(places: [Place], selectedOnly: Bool) -> [Place] {
        var x = [Place]()
        
        x.append(contentsOf: self.selectedPlaces)

        for p in x {
            p.isChecked = true
        }
        
        if selectedOnly {
            return x
        }
        
        x.append(contentsOf: places)

        return x
    }
}
