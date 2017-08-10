//
//  CreateUsernameViewController.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/24/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 6
    }
    
    // MARK: - IBActions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        let dispatchGroup = DispatchGroup()
        let ref = Database.database().reference().child("users")

        dispatchGroup.enter()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let snap = snapshot.value as? [String: Any]
            
            for value in (snap?.values)! {
                let userDict = value as? [String: String]
                if let name = userDict?["username"] {
                    if name == username {
                        return
                    }
                }
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) { 
            UserService.create(firUser, username: username) { (user, error) in
                guard let user = user else {
                    
                    let alert = UIAlertController(title: "Username already taken!", message: "Choose another username.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
            
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
