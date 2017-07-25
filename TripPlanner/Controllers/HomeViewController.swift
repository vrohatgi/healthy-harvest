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

class HomeViewController: UIViewController {

    // MARK: - Subviews
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var beachesButton: UIButton!
    @IBOutlet weak var trailsButton: UIButton!
    @IBOutlet weak var poolsButton: UIButton!
    @IBOutlet weak var campgroundsButton: UIButton!
    @IBOutlet weak var parksButton: UIButton!
    @IBOutlet weak var lakesButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func lakesButtonTapped(_ sender: UIButton) {
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
    @IBAction func locationButtonTapped(_ sender: UIButton) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "pools" {
                print("pools button tapped")
            }
        }
        if let identifier = segue.identifier {
            if identifier == "beaches" {
                print("beaches button tapped")
            }
        }
        if let identifier = segue.identifier {
            if identifier == "trails" {
                print("trails button tapped")
            }
        }
        if let identifier = segue.identifier {
            if identifier == "campgrounds" {
                print("campgrounds button tapped")
            }
        }
        if let identifier = segue.identifier {
            if identifier == "lakes" {
                print("lakes button tapped")
            }
        }
        if let identifier = segue.identifier {
            if identifier == "parks" {
                print("parks button tapped")
            }
        }
    }
}
