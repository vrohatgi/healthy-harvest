//
//  FriendsViewController.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/31/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class FriendsViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var eventPlaces = [Place]()
    
    @IBOutlet weak var eventNameTextField: UITextField!
    
    // MARK: - Properties
    
    var users = [User]()
    
    // MARK: - IBActions 
    
    @IBAction func didTapCreateEventButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(eventPlaces)
        
        // remove separators for empty cells
        friendsTableView.tableFooterView = UIView()
        friendsTableView.rowHeight = 71
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        cell.delegate = self as FriendsTableViewCellDelegate
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: FriendsTableViewCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        cell.usernameLabel.text = user.username
        cell.inviteButton.isSelected = user.isInvited
    }
}

extension FriendsViewController: FriendsTableViewCellDelegate {
    func didTapInviteButton(_ inviteButton: UIButton, on cell: FriendsTableViewCell) {
        guard let indexPath = friendsTableView.indexPath(for: cell) else { return }
        
        inviteButton.isUserInteractionEnabled = false
        let friend = users[indexPath.row]
        
        InviteService.setIsInvited(!friend.isInvited, places: eventPlaces, eventName: eventNameTextField.text!, fromCurrentUserTo: friend) { (success) in
            defer {
                inviteButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            friend.isInvited = !friend.isInvited
            self.friendsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
