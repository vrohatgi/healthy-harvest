//
//  InviteService.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/29/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct InviteService {
    
    private static func inviteUser(_ user: User, places: [Place], eventName: String, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        let inviteData = ["peopleWhoInvitedMe/\(user.uid)/\(currentUID)" : true, "friendsInvited/\(currentUID)/\(user.uid)" : true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(inviteData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
        }
    }
    
    private static func uninviteUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let inviteData = ["peopleWhoInvitedMe/\(user.uid)/\(currentUID)" : NSNull(),
                          "friendsInvited/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(inviteData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(error == nil)
        }
    }
    
    // follower = friend who got invited; followee = friend who invited current user
    
    static func setIsInvited(_ isFollowing: Bool, places: [Place], eventName: String, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            inviteUser(followee, places: places, eventName: eventName, forCurrentUserWithSuccess: success)
        } else {
            uninviteUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserInvited(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
//    private static func create(aspectHeight: CGFloat) {
//        let currentUser = User.current
//        
//        
//        let rootRef = Database.database().reference()
//        let newEventRef = rootRef.child("events").child(currentUser.uid).childByAutoId()
//        let newEventKey = newEventRef.key
//        
//        
//        UserService.friendsInvited(for: currentUser) { (followerUIDs) in
//            
//            let eventCreatedDict = ["creator_uid" : currentUser.uid]
//            
//            
//            var updatedData: [String : Any] = ["eventsVC/\(currentUser.uid)/\(newEventKey)" : eventCreatedDict]
//            
//            
//            for uid in followerUIDs {
//                updatedData["eventsVC/\(uid)/\(newEventKey)"] = eventCreatedDict
//            }
//            
//            
//            rootRef.updateChildValues(updatedData)
//        }
//    }
}
