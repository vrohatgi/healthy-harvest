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
       
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
       
        authUI.delegate = self
        
       
        let myProviders: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        authUI.providers = myProviders

    
        let authViewController = authUI.authViewController()
        
        //HAHA
        
        authViewController.isNavigationBarHidden = false

        present(authViewController, animated: true)
        
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            print(error)
            return
            //assertionFailure("Error signing in: \(error.localizedDescription)")
            //return
        }
        
        guard let user = user
            else { return }
      
        let userRef = Database.database().reference().child("users").child(user.uid)
        
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
        
            }
        }
    }
}
