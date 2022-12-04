//
//  LoginViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 12/3/22.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let accessToken = AccessToken.current {
            print(accessToken)
            Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)) { result, error in
                if error == nil, let authResult = result {
                    print(authResult)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
    @IBAction func signInButtonTapped() {
        
        loginWithFacebook()
    }
    
    private func loginWithFacebook() {
        
    }
}
