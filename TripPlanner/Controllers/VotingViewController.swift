//
//  EventsDetailsViewController.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 8/2/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class VotingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventID: String = ""
    
    var event = Event(id: "hi", createdBy: "vanya", eventName: "picnic", invitedUsers: ["poop"], places: ["butt"], numberOfVotes: 10)
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var peopleVoting: UILabel!

    @IBOutlet weak var votingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventName.text = event.eventName
        peopleVoting.text = "\(event.invitedUsers)"
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return event.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingTableViewCell") as! VotingTableViewCell
        
        cell.totalVotesLabel.text = "\(event.numberOfVotes)"
        //        cell.voteButton.isSelected = event.
        cell.placeInfoLabel.text = event.places[indexPath.row]
        return cell
    }
}
