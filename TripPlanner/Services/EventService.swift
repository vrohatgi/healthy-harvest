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
    
    static func getEventInfo(eventID: String, success: @escaping (Event, [Int]) -> (Void)) {
        let ref = Database.database().reference().child("events").child(eventID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot value: \(snapshot.value ?? "")")
            
            let eventInfo = snapshot.value as? NSDictionary
            let createdBy = eventInfo?["createdBy"] as? String ?? ""
            let eventName = eventInfo?["eventName"] as? String ?? ""
            let invitedUsers = eventInfo?["invitedUsers"] as? [String] ?? [""]

            let places = buildPlaces(placesArr: eventInfo?["places"] as? [Any] ?? [])
            
            let votes = eventInfo?["vote_count"] as? Int ?? 0
            
            let event = Event(id: eventID, createdBy: createdBy, eventName: eventName, invitedUsers: invitedUsers, places: places, numberOfVotes: votes)

            let ref2 = Database.database().reference()
                .child("users")
                .child(User.current.uid)
                .child("events")
                .child(eventID)
                .child("places")
            
            ref2.observeSingleEvent(of: .value, with: { (snap) in
                var votedPlaces = [Int](repeating: 0, count: places.count)
                
                for (k, v) in snap.value as? [String: Int] ?? [:] {
                    votedPlaces[Int(k)!] = v
                }
                
                success(event, votedPlaces)
            })
        })
        

    }
    
    static func buildPlaces(placesArr: [Any]) -> [Place] {
        var places = [Place]()
        
        for placeInfo in placesArr {
            let dict = placeInfo as? NSDictionary
            let name = dict?["name"] as? String ?? ""
            let vicinity = dict?["vicinity"]  as? String ?? ""
            let votes = dict?["votes"] as? Int ?? 0
            
            let p = Place(name: name, vicinity: vicinity, types: [], votes: votes)
            
            places.append(p)
        }
        
        return places
    }
    
    static func buildPlaceArray(places: [Place]) -> [Any] {
        var pArr = [Any]()
        for p in places {
            pArr.append(["name": p.name, "vicinity": p.vicinity, "votes": p.votes])
        }
        
        return pArr
    }
    
    static func updateEventVote(eventId: String, placeIndex: Int, cnt: Int, success: @escaping (Bool) -> (Void)) {
        let ref = Database.database().reference()
            .child("events")
            .child(eventId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let eventInfo = snapshot.value as? NSDictionary

            let places = buildPlaces(placesArr: eventInfo?["places"] as? [Any] ?? [])

            places[placeIndex].votes += cnt
            
            ref.updateChildValues(["places": buildPlaceArray(places: places)])
        })
        
        let ref2 = Database.database().reference()
            .child("users")
            .child(User.current.uid)
            .child("events")
            .child(eventId)
            .child("places")
        
        ref2.updateChildValues(["\(placeIndex)": cnt])
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
