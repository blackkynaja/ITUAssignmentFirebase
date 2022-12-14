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

protocol LoginViewControllerDelegate: AnyObject {
    func loginSuccessFully()
}

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    weak var delegate: LoginViewControllerDelegate?
    
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
        self.loginStackView.addArrangedSubview(loginButton)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let accessToken = AccessToken.current {
            print(accessToken)
            Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)) { result, error in
                if error == nil, let authResult = result {
                    print(authResult)
                    self.dismiss(animated: true)
                    self.delegate?.loginSuccessFully()
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    private func loginWithEmail(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            print(result)
            print(error)
            
            if error == nil, let authResult = result {
                print(authResult)
                self.dismiss(animated: true)
                self.delegate?.loginSuccessFully()
            } else {
                let alert = UIAlertController(title: "Login", message: "Something's wrong, please try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
    
    @IBAction func loginTapped() {
        
        loginWithEmail(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}
