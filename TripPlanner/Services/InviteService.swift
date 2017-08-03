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
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(error == nil)
        }
    }
    
    private static func uninviteUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(error == nil)
        }
    }
    
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
}
