//
//  TabViewControllerswift.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//

import UIKit
import Foundation

class TabViewController: UITabBarController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var firstName: String?
    var lastName: String?
    var removeIndex: Int?
    
    @IBAction func logoutButtonTapped(_ sender: Any) {

        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UdacityClient.sharedInstance().deleteSession() { (success, sessionID, error) in
            
            performUIUpdatesOnMain {
                
                if success {
                    self.present(loginPage, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Unable to log out", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addPinPressed(_ sender: Any) {
        
        ParseClient.sharedInstance().getSingleStudentLocation() { (result, error) in
            if (error != nil){
                return
            }

            
            let dictionary = result![0]
            
            if (ParseClient.JSONResponseKeys.ObjectId == "objectId"){
                guard let objectID = dictionary[ParseClient.JSONResponseKeys.ObjectId!] as? String else {
                    print("objectID not found")
                    return
                }
                
                ParseClient.JSONResponseKeys.ObjectId = objectID
            }
            print("ObjectID = ", ParseClient.JSONResponseKeys.ObjectId as Any)
            
            
            performUIUpdatesOnMain {
                print("TESTING: ", result==nil)
                if result != nil {
                    let alert = UIAlertController(title: "Alert", message: "Do you want to overwrite your location?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        self.openPinVC()
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.openPinVC()
                }
            }
        }
    }
    
    @IBAction func refreshPinLocations(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:  "SuccessNotification"), object: self)
    }
    
    func getUserData() {
        UdacityClient.sharedInstance().getUserData() { (success, firstName, lastName, error) in
            
            guard error == nil else {
                let alert = UIAlertController(title: "Alert", message: "Couldn't find your first and last name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.firstName = firstName
            self.lastName = lastName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UdacityClient.Constants.UdacityLoginOccured == true{
            getUserData()
        }
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func openPinVC() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        controller.firstName = self.firstName
        controller.lastName = self.lastName
        present(controller, animated: true, completion: nil)
    }
    
    class func sharedInstance() -> TabViewController {
        struct Singleton {
            static var sharedInstance = TabViewController()
        }
        return Singleton.sharedInstance
    }
    
}

