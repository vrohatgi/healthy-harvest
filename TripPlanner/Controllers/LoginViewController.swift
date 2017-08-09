//
//  LoginViewController.swift
//  TripPlanner
//
//  Created by vanya rohatgi on 7/24/17.
//  Copyright © 2017 Vanya Rohatgi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("login button tapped")
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // add google provider
        let myProviders: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        authUI.providers = myProviders

        
        // 3
        let authViewController = authUI.authViewController()
        
        authViewController.isNavigationBarHidden = true

        present(authViewController, animated: true)
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // 1
        guard let user = user
            else { return }
        
        // 2
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        // 3
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                User.setCurrent(user)
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
        
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                ///self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
        }
    }
}
