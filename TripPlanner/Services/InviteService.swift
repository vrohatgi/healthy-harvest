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
    
    static func isUserInvited(_ user: User,
                              byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        
        let ref = Database
            .database()
            .reference()
            .child("followers")
            .child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let _ = snapshot.value as? [String : Bool] {
                    completion(true)
                } else {
                    completion(false)
                }
                
            })
    }
    
}
