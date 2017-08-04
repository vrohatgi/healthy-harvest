//
//  VoteService.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct EventService {
    
    static func saveEvent(places: [[String: String]], users: [String], eventName: String, success: @escaping (Bool) -> (Void)) {
        let ref = Database.database().reference().child("events").childByAutoId()
        let userData = ["users": users, "places": places, "eventName": eventName] as [String : Any]
        ref.updateChildValues(userData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
        }
        
        let ref2 = Database.database().reference().child("users").child(User.current.uid)

        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            let snap = snapshot.value as! [String: Any]
            var eventsArr = [String]()

            if let event = (snap["events"] as? [String]) {
                eventsArr = event
                eventsArr.append(ref.key)
            } else {
                eventsArr = [ref.key]
            }
            
            let eventList = ["events": eventsArr]
            ref2.updateChildValues(eventList)
        })
    }
}
