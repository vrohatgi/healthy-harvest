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
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var votingTableViewController: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingTableViewCell") as! VotingTableViewCell
        
        return cell
    }
}
