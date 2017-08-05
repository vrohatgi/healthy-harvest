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

    /*
    static func getEvents(success: @escaping () -> (Void)) {
        let ref2 = Database.database().reference().child("users").child(User.current.uid)
        
    }
 */
    
    static func saveEvent(places: [[String: String]], users: [String], eventName: String, success: @escaping (Bool) -> (Void)) {
        
        // 1. lets save a new event under "events" key
        
        // 1.a creates a new "events.eventID"
        let ref = Database.database().reference().child("events").childByAutoId()
        
        let newEventId = ref.key

        // 1.b lets create eventData to attach to the eventID we created above
        var userList = [String]()
        
        userList.append(User.current.uid)
        userList.append(contentsOf: users)
        
        let eventData = ["invitedUsers": userList, "places": places, "eventName": eventName, "createdBy": User.current.uid] as [String : Any]
        
        // 1.c attach eventData to events.eventID
        ref.updateChildValues(eventData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
        }
        
        // 2. update the event inside of "users.currentUserId.events[]" array
        for userId in userList {
            let ref = Database.database().reference().child("users").child(userId)

            // 2.a get the eventsArr and append our new event to it
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let snap = snapshot.value as! [String: Any]
                var eventsArr = [String]()
                
                if let event = (snap["events"] as? [String]) {
                    eventsArr = event
                    eventsArr.append(newEventId)
                } else {
                    eventsArr = [newEventId]
                }
                
                let eventList = ["events": eventsArr]
                ref.updateChildValues(eventList)
            })
        }
        
    }
}
