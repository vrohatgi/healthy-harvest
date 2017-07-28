//
//  PlacesTableViewController.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/27/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit

class PlacesTableViewController: UITableViewController {
    
    @IBOutlet var placesTableView: UITableView!
    
    var places = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods

//    private func loadSamplePlaces() {
//        let place1 = "City Beach"
//        let place2 = "Lake Elizabeth"
//        let place3 = "Mission Peak"
//        
//        places += [place1, place2, place3]
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlacesTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlacesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlacesTableViewCell.")
        }
        
        let place = places[indexPath.row]
        cell.placesLabel.text = place
        
        // Configure the cell...
        
        return cell
    }
}
