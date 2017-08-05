//
//  Event.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/4/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class Event: NSObject {
    
    var id: String
    var createdBy: String
    var eventName: String
    var invitedUsers: [String]
    var places: [Place]
    var numberOfVotes: Int
    
    init(id: String, createdBy: String, eventName: String, invitedUsers: [String], places: [Place], numberOfVotes: Int) {
        self.createdBy = createdBy
        self.eventName = eventName
        self.invitedUsers = invitedUsers
        self.places = places
        self.numberOfVotes = numberOfVotes
        self.id = id
        
        super.init()
    }
    
    init(id: String, createdBy: String, name: String) {
        self.id = id
        self.eventName = name
        self.createdBy = createdBy
        self.invitedUsers = []
        self.places = []
        self.numberOfVotes = 0
        
        super.init()
    }
}
