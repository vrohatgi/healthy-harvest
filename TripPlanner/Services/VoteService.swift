//
//  VoteService.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/5/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct VoteService {
    
    static func create(for event: Event, success: @escaping (Bool) -> Void) {
        
        let _ = Database.database().reference().child("events").child(event.id)
    }
}
