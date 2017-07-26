//
//  HomeViewController.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/24/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var places = [String]()
    
    // MARK: - Private Methods
    
    private func loadSamplePlaces() {
        let place1 = "Fremont"
        let place2 = "Newark"
        let place3 = "Hayward"
        
        places += [place1, place2, place3]
    }
    
    
    // MARK: - Subviews
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var beachesButton: UIButton!
    @IBOutlet weak var trailsButton: UIButton!
    @IBOutlet weak var poolsButton: UIButton!
    @IBOutlet weak var campgroundsButton: UIButton!
    @IBOutlet weak var parksButton: UIButton!
    @IBOutlet weak var lakesButton: UIButton!
    
    @IBOutlet weak var placesTableView: UITableView!
    // MARK: - IBActions
    
    @IBAction func lakesButtonTapped(_ sender: UIButton) {
        // make a call to google places api
        // send in find "lakes" near "selectedLocation"
    }
    
    @IBAction func parksButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func campgroundsButtonTapped(_ sender: UIButton) {
    }
    @IBAction func beachesButtonTapped(_ sender: UIButton) {
    }
    @IBAction func trailsButtonTapped(_ sender: UIButton) {
    }
    @IBAction func poolsButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func editingSearchBegin(_ sender: UITextField) {
        
        // Present the Autocomplete view controller when the button is pressed.
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        
        present(autocompleteController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSamplePlaces()
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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


extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        locationTextField.text = place.name
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
