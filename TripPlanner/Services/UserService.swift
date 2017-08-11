//
//  UserService.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/24/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func report(uid: String) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.updateChildValues(["isReported": true])
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?, String?) -> Void) {
        // check for unique username
        let refUNames = Database.database().reference().child("usernames").child(username)
        
        refUNames.observeSingleEvent(of: .value, with: { snap in
            let x = snap.value as? String ?? ""

            if x.characters.count > 0 {
                return completion(nil, "Username: \(username) already exists")
            }
            
            let userAttrs = ["username": username, "isReported": false] as [String : Any]
            
            let ref = Database.database().reference().child("users").child(firUser.uid)
            ref.setValue(userAttrs) { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil, "Unable to save user attributes")
                }
                
                Database.database().reference()
                    .child("usernames")
                    .child(username)
                    .setValue("created")
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    return completion(user, nil)
                })
            }
            
        })
        
    }
    
    static func friendsInvited(for user: User, completion: @escaping ([String]) -> Void) {
        let friendsRef = Database.database().reference().child("friends").child(user.uid)
        
        friendsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let friendsDict = snapshot.value as? [String : Bool] else {
                return completion([])
            }
            
            let friendsKeys = Array(friendsDict.keys)
            completion(friendsKeys)
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")
        
        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            // 3
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            
            // 4
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                // 5
                InviteService.isUserInvited(user) { (isInvited) in
                    user.isInvited = isInvited
                    dispatchGroup.leave()
                }
            }
            
            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func getEvents(success: @escaping ([Event]) -> (Void)) {
        // 1. lets get current user key
        let ref = Database.database().reference()
            .child("users").child(User.current.uid).child("events")
        
        // 2. now lets get events he is invited to
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let events = snapshot.value as? [String: Any]
            
            var eventsArr = [Event]()
            
            for (eventId, value) in events ?? [:] {
                let dict = value as? [String: Any]
                eventsArr.append(Event(id: eventId, createdBy: dict?["createdBy"] as? String ?? "", name: dict?["name"] as? String ?? ""))
            }
            
            success(eventsArr)
        })
    }
}

