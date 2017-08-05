//
//  VotingTableViewCell.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

protocol VotingTableViewCellDelegate: class {
    func didTapVoteButton(_ voteButton: UIButton, on cell: VotingTableViewCell)
}

class VotingTableViewCell: UITableViewCell {
    
    weak var delegate: VotingTableViewCellDelegate?

    // MARK: -IBOutlets
    
    @IBOutlet weak var totalVotesLabel: UILabel!
    
    @IBOutlet weak var placeInfoLabel: UILabel!
    
    @IBOutlet weak var voteButton: UIButton!
    
    // MARK: -IBActions
    
    @IBAction func didTapVoteButton(_ sender: UIButton) {
        delegate?.didTapVoteButton(sender, on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        inviteButton.layer.borderColor = UIColor.lightGray.cgColor
        //        inviteButton.layer.borderWidth = 1
        //        inviteButton.layer.cornerRadius = 6
        //        inviteButton.clipsToBounds = true
        
        voteButton.setTitle("Vote", for: .normal)
        voteButton.setTitle("Voted", for: .selected)
    }
    
}
