//
//  LinkViewController.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//


import Foundation
import UIKit
import MapKit

class LinkViewController: UIViewController {
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?

    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true;
        PinShowOnMap()
        
    }
    func PinShowOnMap() {
        
        geocoder.geocodeAddressString(mapString!) { (placemarks, error) in
            
            if let placemark = placemarks?.first  {
                
          
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude

                let mapKitPlacemark = MKPlacemark(placemark: placemark)
                self.mapView.addAnnotation(mapKitPlacemark)
              
                self.mapView.centerCoordinate = (placemark.location?.coordinate)!
                // Instantiate an MKCoordinateSpanMake
                let coordinateSpan = MKCoordinateSpan(latitudeDelta: 80,longitudeDelta: 80)
                // Instantiate an MKCoordinateRegion
                let coordinateRegion = MKCoordinateRegion(center: (placemark.location?.coordinate)!, span: coordinateSpan)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        mediaURL = linkTextField.text
        
        if let uniqueKeyUnwrapped = UdacityClient.sharedInstance().userID,
            let firstNameUnwrapped = firstName,
            let lastNameUnwrapped = lastName,
            let mapStringUnwrapped = mapString,
            let mediaURLUnwrapped = mediaURL,
            let latitudeUnwrapped = latitude,
            let longitudeUnwrapped = longitude {
            
            
            let loggedInUser: String = "{\"uniqueKey\": \"\(uniqueKeyUnwrapped)\", \"firstName\": \"\(firstNameUnwrapped)\", \"lastName\": \"\(lastNameUnwrapped)\",\"mapString\": \"\(mapStringUnwrapped)\", \"mediaURL\": \"\(mediaURLUnwrapped)\",\"latitude\": \(latitudeUnwrapped), \"longitude\": \(longitudeUnwrapped)}"
            
            
            if ParseClient.JSONResponseKeys.ObjectId != nil {
                
                ParseClient.sharedInstance().putStudentLocation(studentDictionary: loggedInUser) { (updatedAt, error) in
                    
                    performUIUpdatesOnMain {
                        if error == nil {
                            
                            let loggedInUserDictionary = self.convertToDictionary(text: loggedInUser)
                            StudentInfo.studentLocationList.append(loggedInUserDictionary!)
                            print(StudentInfo.studentLocationList)
                            
                            
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Alert", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                
            } else {
                
                ParseClient.sharedInstance().postStudentLocation(studentDictionary: loggedInUser) { (objectID, error) in
                    
                    performUIUpdatesOnMain {
                        if error == nil {
                            
                            let loggedInUserDictionary = self.convertToDictionary(text: loggedInUser)
                            StudentInfo.studentLocationList.append(loggedInUserDictionary!)
                            print(StudentInfo.studentLocationList)
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Alert", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func convertToDictionary(text: String) -> StudentInfo? {
        if let data = text.data(using: .utf8) {
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                return StudentInfo(dictionary: dictionary!)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

