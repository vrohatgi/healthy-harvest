//
//  FriendsTableViewCell.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/31/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

protocol FriendsTableViewCellDelegate: class {
    func didTapInviteButton(_ inviteButton: UIButton, on cell: FriendsTableViewCell)
}

class FriendsTableViewCell: UITableViewCell {
    
    weak var delegate: FriendsTableViewCellDelegate?
    
    // MARK: - Properties
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!

    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        inviteButton.layer.borderColor = UIColor.lightGray.cgColor
//        inviteButton.layer.borderWidth = 1
//        inviteButton.layer.cornerRadius = 6
//        inviteButton.clipsToBounds = true
        
        inviteButton.setTitle("Invite", for: .normal)
        inviteButton.setTitle("Invited", for: .selected)
    }
    
    // MARK: - IBActions
    
    
    @IBAction func inviteButtonTapped(_ sender: UIButton) {
        print("invite button tapped")
        delegate?.didTapInviteButton(sender, on: self)
    }
    
}
