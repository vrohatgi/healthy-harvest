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
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var displayArr = [Place]() {
        didSet {
            self.placesTableView.reloadData()
        }
    }
    
    var myPlaces = EventBuilder()
    
    var selectedLongitude: Double = 0.0
    var selectedLatitude: Double = 0.0
    let activitiesKey = "AIzaSyA1lOPwR0gcLPOV5oy0FYKbc01UDLeVMfE"
    
    // MARK: - Subviews
    
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var beachesButton: UIButton!
    @IBOutlet weak var trailsButton: UIButton!
    @IBOutlet weak var poolsButton: UIButton!
    @IBOutlet weak var campgroundsButton: UIButton!
    @IBOutlet weak var parksButton: UIButton!
    @IBOutlet weak var lakesButton: UIButton!
    @IBOutlet weak var placesTableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        //self.performSegue(withIdentifier: "nextButton", sender: self)
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
        
        self.myPlaces.sync(places: self.displayArr)

        myVC.eventPlaces = self.myPlaces.buildList(places: [Place](), selectedOnly: true)

        navigationController?.pushViewController(myVC, animated: true)
        
        print("hi next working")
    }
    
    func fetchActivities(location: String, radius: Int, type: String, keyword: String, key: String) {
        var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        url += "location=\(location)"
        url += "&radius=\(radius)"
        url += "&type=\(type)"
        url += "&keyword=\(keyword)"
        url += "&key=\(key)"
        
        print(url)
        
        Alamofire.request(url).responseJSON { (response) in
            let result = response.result.value as! [String: Any]
            let placeArr = result["results"] as! NSArray
            
            var list = [Place]()
            let space = ""
            for place in placeArr {
                let info = place as! [String: Any]
                
                let x = "\(info["vicinity"] ?? space)"
                
                let p = Place(name: info["name"] as! String,
                              vicinity: x,
                              types: info["types"] as! [String])
                
                list.append(p)
            }
            
            self.myPlaces.sync(places: self.displayArr)
            
            self.displayArr = self.myPlaces.buildList(places: list, selectedOnly: false)
        }
    }
    
    
    @IBAction func lakesButtonTapped(_ sender: UIButton) {
        fetchActivities(
            location: "\(selectedLatitude),\(selectedLongitude)",
            radius: 30000,
            type: "",
            keyword: "lake",
            key: activitiesKey)
    }
    
    @IBAction func parksButtonTapped(_ sender: UIButton) {
        fetchActivities(
            location: "\(selectedLatitude),\(selectedLongitude)",
            radius: 30000,
            type: "",
            keyword: "park",
            key: activitiesKey)
    }
    
    @IBAction func campgroundsButtonTapped(_ sender: UIButton) {
        fetchActivities(
            location: "\(selectedLatitude),\(selectedLongitude)",
            radius: 30000,
            type: "",
            keyword: "campground",
            key: activitiesKey)
    }
    
    @IBAction func beachesButtonTapped(_ sender: UIButton) {
        fetchActivities(
            location: "\(selectedLatitude),\(selectedLongitude)",
            radius: 30000,
            type: "",
            keyword: "beach",
            key: activitiesKey)
    }
    
    @IBAction func trailsButtonTapped(_ sender: UIButton) {
        fetchActivities(
            location: "\(selectedLatitude),\(selectedLongitude)",
            radius: 30000,
            type: "",
            keyword: "trail",
            key: activitiesKey)
    }
    
    @IBAction func poolsButtonTapped(_ sender: UIButton) {
        fetchActivities(
            location: "\(selectedLatitude),\(selectedLongitude)",
            radius: 30000,
            type: "",
            keyword: "pool",
            key: activitiesKey)
    }
    
    @IBAction func editingSearchBegin(_ sender: UITextField) {
        
        // Present the Autocomplete view controller when the button is pressed.
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil // hides next button. how/where to bring back?
        placesTableView.delegate = self
        placesTableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlacesTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlacesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlacesTableViewCell.")
        }
        
        let place = displayArr[indexPath.row]
        
        if place.isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        //Loop through place.types and add to a new variable sting to display down here \/
        cell.placesLabel.text = "\(place.name) \(place.vicinity) \(place.types)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                displayArr[indexPath.row].isChecked = false
            } else {
                cell.accessoryType = .checkmark
                displayArr[indexPath.row].isChecked = true
            }
        }
    }
}


extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let space = ""
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? space)")
        print("Place attributions: \(String(describing: place.attributions))")
        
        print("\(place.coordinate)")
        
        selectedLatitude = place.coordinate.latitude
        selectedLongitude = place.coordinate.longitude
        
        locationTextField.text = "\(place.formattedAddress ?? space)"
        
        beachesButton.isHidden = false
        trailsButton.isHidden = false
        poolsButton.isHidden = false
        campgroundsButton.isHidden = false
        parksButton.isHidden = false
        lakesButton.isHidden = false
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
