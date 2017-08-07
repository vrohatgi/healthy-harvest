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
    
    var event = Event(id: "hi", createdBy: "vanya", eventName: "picnic", invitedUsers: ["poop"], places: [Place(name: "butt", vicinity: "poop", types: [])], numberOfVotes: 10)
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var peopleVoting: UILabel!

    @IBOutlet weak var votingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got eventId: \(self.eventID)")
        
        EventService.getEventInfo(eventID: eventID) { (eventInfo) in
            self.eventName.text = eventInfo.eventName
            self.peopleVoting.text = "\(eventInfo.invitedUsers.joined(separator: ", "))"
            self.event = eventInfo
            
            self.votingTableView.reloadData()
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingTableViewCell") as! VotingTableViewCell
        
        cell.delegate = self as VotingTableViewCellDelegate

        cell.totalVotesLabel.text = "\(event.numberOfVotes)"

        cell.placeInfoLabel.text = "\(event.places[indexPath.row].name) \(event.places[indexPath.row].vicinity)"
        
        return cell
    }
}

extension VotingViewController: VotingTableViewCellDelegate {
    func didTapVoteButton(_ inviteButton: UIButton, on cell: VotingTableViewCell) {
        print("inside didTapVoteButton")
        
        guard let indexPath = votingTableView.indexPath(for: cell) else { return }
        
        print("voting row: \(indexPath.row)")
    }
}


