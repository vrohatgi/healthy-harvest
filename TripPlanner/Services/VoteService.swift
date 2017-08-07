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
    
    var hasVoted = false
    
    static func create(for event: Event, success: @escaping (Bool) -> Void) {
        
        let votesRef = Database.database().reference().child("events").child(event.id)
        votesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let voteCountRef = Database.database().reference().child("events").child(event.id).child("vote_count")
            voteCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                } else {
                    success(true)
                }
            })
        }
    }
    
    static func delete(for event: Event, success: @escaping (Bool) -> Void) {
        let votesRef = Database.database().reference().child("events").child(event.id)
        votesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let voteCountRef = Database.database().reference().child("events").child(event.id).child("vote_count")
            voteCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount - 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                } else {
                    success(true)
                }
            })
        }
    }
    
    static func isPlaceVotedFor(_ event: Event, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        let votesRef = Database.database().reference().child("events").child(event.id)
        votesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
