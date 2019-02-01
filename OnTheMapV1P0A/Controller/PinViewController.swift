//
//  PinViewController.swift
//  
//
//  Created by Farhan Qazi on 1/22/19.
//


import Foundation
import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var firstName: String?
    var lastName: String?
    
    var geoloca = CLGeocoder()
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func findLocationPressed(_ sender: Any) {
        
        MapStringChecker(mapString: locationTextField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    func MapStringChecker(mapString: String) {
        geoloca.geocodeAddressString(mapString) { (placemarks, error) in
            
  
            if error != nil {
                let alert = UIAlertController(title: "Alert", message: "Valid Location please!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LinkViewController") as! LinkViewController

                controller.firstName = self.firstName
                controller.lastName = self.lastName
                

                controller.mapString = self.locationTextField.text
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
