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
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
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
        
        func events(for user: User, completion: @escaping ([Event]) -> Void) {
            let ref = Database.database().reference().child("events")

            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    return completion([])
                }
                
                let dispatchGroup = DispatchGroup()
                /*
                let events: [Event] =
                    snapshot
                        .reversed()
                        .flatMap {
                            guard let event = Event(snapshot: $0)
                                else { return nil }
                            
                            dispatchGroup.enter()
                            
                            VoteService.isPlaceVotedFor(place) { (isVotedFor) in
                                place.isVotedFor = isVotedFor
                                
                                dispatchGroup.leave()
                            }
                            
                            return event
                }
                */
                dispatchGroup.notify(queue: .main, execute: {
                    completion([])
                })
            })
        }
    }
    
//    static func events(for user: User, completion: @escaping ([Place]) -> Void) {
//        let ref = Database.database().reference().child("events").child(user.uid)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//            else {
//                return completion([])
//            }
//        }
//    )}
}
