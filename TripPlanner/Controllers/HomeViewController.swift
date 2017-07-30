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
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var places = [String]()
    var selectedActivities = [String]()
    
    var selectedLongitude: Double = 0.0
    var selectedLatitude: Double = 0.0
    let activitiesKey = "AIzaSyA1lOPwR0gcLPOV5oy0FYKbc01UDLeVMfE"
    
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
    
    func fetchActivities(location: String, radius: Int, type: String, keyword: String, key: String) {
        var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        url += "location=\(location)"
        url += "&radius=\(radius)"
        url += "&type=\(type)"
        url += "&keyword=\(keyword)"
        url += "&key=\(key)"
        
        print(url)
        
        // fill in places array
        
        Alamofire.request(url).responseJSON { (response) in
            //print(response.result.value)
            self.places.removeAll()
            let result = response.result.value as! [String: Any]
            let placeArr = result["results"] as! NSArray
            for place in placeArr {
                let name = place as! NSDictionary
                self.places.append(name["name"] as! String)
                print(place)
            }
            
            self.placesTableView.reloadData()
        }
    }
    
    
    @IBAction func lakesButtonTapped(_ sender: UIButton) {
        
        fetchActivities(location: "\(selectedLatitude),\(selectedLongitude)", radius: 30000, type: "", keyword: "lake", key: activitiesKey)
    }
    
    @IBAction func parksButtonTapped(_ sender: UIButton) {
        fetchActivities(location: "\(selectedLatitude),\(selectedLongitude)", radius: 30000, type: "park", keyword: "", key: activitiesKey)
    }
    
    @IBAction func campgroundsButtonTapped(_ sender: UIButton) {
        fetchActivities(location: "\(selectedLatitude),\(selectedLongitude)", radius: 30000, type: "campground", keyword: "", key: activitiesKey)
    }
    @IBAction func beachesButtonTapped(_ sender: UIButton) {
        fetchActivities(location: "\(selectedLatitude),\(selectedLongitude)", radius: 30000, type: "", keyword: "beach", key: activitiesKey)
    }
    @IBAction func trailsButtonTapped(_ sender: UIButton) {
        fetchActivities(location: "\(selectedLatitude),\(selectedLongitude)", radius: 30000, type: "", keyword: "trail", key: activitiesKey)
    }
    @IBAction func poolsButtonTapped(_ sender: UIButton) {
        fetchActivities(location: "\(selectedLatitude),\(selectedLongitude)", radius: 30000, type: "", keyword: "pool", key: activitiesKey)
    }
    
    @IBAction func editingSearchBegin(_ sender: UITextField) {
        
        // Present the Autocomplete view controller when the button is pressed.
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.delegate = self
        placesTableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
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
        
        print("\(place.coordinate)")
        selectedLatitude = place.coordinate.latitude
        selectedLongitude = place.coordinate.longitude
        
        locationTextField.text = place.name
        
        beachesButton.isEnabled = true
        trailsButton.isEnabled = true
        poolsButton.isEnabled = true
        campgroundsButton.isEnabled = true
        parksButton.isEnabled = true
        lakesButton.isEnabled = true
        
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
