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
    var votedPlaces = [Int](repeating: 0, count: 1)
    var event = Event(id: "hi", createdBy: "vanya", eventName: "picnic", invitedUsers: ["poop"], places: [Place(name: "butt", vicinity: "poop", types: [], votes: 1)], numberOfVotes: 10)
    var placeIsVotedFor: Bool = false
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var peopleVoting: UILabel!

    @IBOutlet weak var votingTableView: UITableView!
    
    @IBAction func didTapVoteButton(_ sender: UIButton) {
        if placeIsVotedFor == false {
            placeIsVotedFor = true } else {
                self.placeIsVotedFor = false
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got eventId: \(self.eventID)")
        
        EventService.getEventInfo(eventID: eventID) { (eventInfo, votedPlaces) in
            print("*** votingController: votedPlaces=\(votedPlaces)")

            self.eventName.text = eventInfo.eventName
            self.peopleVoting.text = "\(eventInfo.invitedUsers.joined(separator: ", "))"
            self.event = eventInfo
            self.votedPlaces = votedPlaces
            
            self.votingTableView.reloadData()
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingTableViewCell") as! VotingTableViewCell
        
        cell.delegate = self as VotingTableViewCellDelegate

        cell.totalVotesLabel.text = "\(event.places[indexPath.row].votes)"

        cell.placeInfoLabel.text = "\(event.places[indexPath.row].name) \(event.places[indexPath.row].vicinity)"

        if votedPlaces[indexPath.row] > 0 {
            cell.voteButton.isSelected = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension VotingViewController: VotingTableViewCellDelegate {
    func didTapVoteButton(_ inviteButton: UIButton, on cell: VotingTableViewCell) {
        
        guard let indexPath = votingTableView.indexPath(for: cell) else { return }
        
        print("voting row: \(indexPath.row)")

        var cnt = 1
        cell.voteButton.isSelected = !cell.voteButton.isSelected

        if votedPlaces[indexPath.row] > 0 {
            cnt *= -1
        }
        
        EventService.updateEventVote(eventId: event.id, placeIndex: indexPath.row, cnt: cnt)  { status in
            self.votedPlaces[indexPath.row] += cnt
            let t = Int(cell.totalVotesLabel.text!)! + cnt
            cell.totalVotesLabel.text = "\(t)"
            print("successfully updated vote \(status)")
        }
        
    }
}


