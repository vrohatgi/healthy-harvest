//
//  VoteService.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct EventService {

    //for the voting vc i need to get the places, who invited & users invited, event name
    
    static func getEventInfo(eventID: String, success: @escaping (Event) -> (Void)) {
        let ref = Database.database().reference().child("events").child(eventID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot value: \(snapshot.value ?? "")")
            
            
            let eventInfo = snapshot.value as? NSDictionary
            
            let createdBy = eventInfo?["createdBy"] as? String ?? ""
            let eventName = eventInfo?["eventName"] as? String ?? ""
            let invitedUsers = eventInfo?["invitedUsers"] as? [String] ?? [""]
            let placesArr = eventInfo?["places"] as? [Any]

            var places = [Place]()
            
            for placeInfo in placesArr ?? [] {
                let dict = placeInfo as? NSDictionary
                let name = dict?["name"] as? String ?? ""
                let vicinity = dict?["vicinity"]  as? String ?? ""
                places.append(Place(name: name, vicinity: vicinity, types: []))
            }
            
            let votes = eventInfo?["vote_count"] as? Int ?? 0
            
            let event = Event(id: eventID, createdBy: createdBy, eventName: eventName, invitedUsers: invitedUsers, places: places, numberOfVotes: votes)

            success(event)
        })
    }
    
    static func getEvents(success: @escaping ([Event]) -> (Void)) {
        // 1. lets get current user key
        let ref = Database.database().reference()
            .child("users").child(User.current.uid).child("events")
        
        // 2. now lets get events he is invited to
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let events = snapshot.value as! [String: Any]
            
            var eventsArr = [Event]()
            
            for (eventId, value) in events {
                let dict = value as? [String: String]
                eventsArr.append(Event(id: eventId, createdBy: dict?["createdBy"] ?? "", name: dict?["name"] ?? ""))
            }
            
            success(eventsArr)
        })        
    }
 
    
    static func saveEvent(places: [[String: String]], users: [User], eventName: String, success: @escaping (Bool) -> (Void)) {
        
        // 1. lets save a new event under "events" key
        
        // 1.a creates a new "events.eventID"
        let ref = Database.database().reference().child("events").childByAutoId()
        
        let newEventId = ref.key

        // 1.b lets create eventData to attach to the eventID we created above
        var userList = [String]()
        
        userList.append(User.current.username)
        
        for user in users {
            if user.isInvited {
                userList.append(user.username)
            }
        }
        
        let eventData = ["invitedUsers": userList, "places": places, "eventName": eventName, "createdBy": User.current.uid] as [String : Any]
        
        // 1.c attach eventData to events.eventID
        ref.updateChildValues(eventData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
        }
        
        // 2. update the event index in "users.currentUserId.events.newEventId.{name,createdBy}" array

        // 2.a make list of user ids we will be updating
        var userIDList = [String]()
        
        userIDList.append(User.current.uid)
        
        for user in users {
            if user.isInvited {
                userIDList.append(user.uid)
            }
        }

        // 2.b update them all with event information
        let eventInfo = [newEventId: ["name": eventName, "createdBy": User.current.username]]
        
        for userID in userIDList {
            let ref = Database.database().reference()
                .child("users").child(userID).child("events")
            
            ref.updateChildValues(eventInfo)
        }
        
    }
}
