//
//  VotingTableViewCell.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class VotingTableViewCell: UITableViewCell {
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var totalVotesLabel: UILabel!
    
    @IBOutlet weak var placeInfoLabel: UILabel!
    
    @IBOutlet weak var voteButton: UIButton!
    
    // MARK: -IBActions
    
    @IBAction func didTapVoteButton(_ sender: Any) {
    }
    
    
}
