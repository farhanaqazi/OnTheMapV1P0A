//
//  LoginViewController.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//

import Foundation
import UIKit


class LoginViewController: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var udacityUsername: UITextField!
    @IBOutlet weak var udacityPassword: UITextField!
    
    func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: false, completion: nil)
    }
    @IBAction func udacityLoginPressed(_ sender: Any) {
        if (self.udacityUsername.text == "" || self.udacityPassword.text == "" ) {
            let alert = UIAlertController(title: "Alert", message: "Must not leave email of passwork blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            UdacityClient.LoginData.username = udacityUsername.text!
            UdacityClient.LoginData.password = udacityPassword.text!
            
            UdacityClient.Constants.UdacityLoginOccured = true
            UdacityClient.sharedInstance().postSession(username: UdacityClient.LoginData.username, password: UdacityClient.LoginData.password) { (success, sessionID, errorString)  in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        let alert = UIAlertController(title: "Alert", message: "Error logging in", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }



    @IBAction func signUpPressed(_ sender: AnyObject) {
        if let signUpURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated") {
            UIApplication.shared.open(signUpURL)
        }
    }




    override func viewDidLoad() {
        super.viewDidLoad()


        subscribeToKeyboardNotifications()
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = protectedPageNav

            subscribeToKeyboardNotifications()
            print("Subscribed to Keyboard Called")

    }




    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

        func keyboardWillShow(_ notification:Notification) {
        if udacityPassword.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }


        /////********************************************Start KEYBOARD MANIPULATION BLOCK *********************************************
        
        // MARK: Step5:  Code for Keyboard Adjustments
        
        //This method subscribe to keyboard notifications will be called in view will appear:
        // In this block of code, the view controller is signing up for the notification
        // when the" . UIKeyboardWillshow/hide " will be coming up
        
        func subscribeToKeyboardNotifications() {
            //Keyboard will show
           NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
          //Keyboard will hide
          NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        // MARK: Step7a: This method being created,Un-subscribes  to keyboard notifications will be called in view will disappear
        
        func unsubscribeFromKeyboardNotifications() {
            print("Unsubscribed from keyboard called")
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            
            
        }
        
        // MARK: Step7b: viewWillDisappear This method ,Un-subscribes  to keyboard notifications
    override func viewWillDisappear(_ animated: Bool) {
            print("View Will Disappear called")
            super.viewWillDisappear(animated)
            unsubscribeFromKeyboardNotifications()
        }
        
        
        
        
        
        
        //// @@@@@@@@@@@@@@@@@@@@@  End: KEYBOARD MANIPULATION BLOCK @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        
        
        
        
        
        
        
        
        
        
        
}

