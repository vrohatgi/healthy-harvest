////
////  EventViewController.swift
////  TripPlanner
////
////  Created by vanya rohatgi on 7/24/17.
////  Copyright © 2017 Vanya Rohatgi. All rights reserved.
////
//

import Foundation
import UIKit
import FirebaseAuth

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var authHandle: AuthStateDidChangeListenerHandle?
    var eventPlaces = [Int: String]()
    
    var eventNames = [Event]()
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func didTapLogOutButton(_ sender: UIBarButtonItem) {
        print("i am in logout!")
        
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
        
        print("iamsignedout")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "VotingViewController") as! VotingViewController
        
        myVC.eventID = self.eventNames[indexPath.row].id
        
        navigationController?.pushViewController(myVC, animated: true)
        
        print("hi selectRow working")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EventsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventsTableViewCell.")
        }
        
        //let place = places[indexPath.row]
        cell.accessoryType = .none
        cell.eventsLabel.text = "\(eventNames[indexPath.row].eventName) by \(eventNames[indexPath.row].createdBy)"
        
        // Configure the cell...
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EventService.getEvents { [unowned self] (events) in
            self.eventNames = events
            
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
    }

}
