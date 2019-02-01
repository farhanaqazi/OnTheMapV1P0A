//
//  ListViewController.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//

import UIKit
import Foundation

class ListViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name(rawValue: "SuccessNotification"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInfo.studentLocationList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Student")!
        let student = StudentInfo.studentLocationList[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = student.firstName
        cell.detailTextLabel?.text = student.mediaURL
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let student = StudentInfo.studentLocationList[indexPath.row]
        
        if let studentURL = URL(string: student.mediaURL!) {
            
            if UIApplication.shared.canOpenURL(studentURL) {
                UIApplication.shared.open(studentURL)
            } else {
                showErrorAlert(messageText: "Not a valid URL.")
            }
        }
    }
    
    @objc func refreshList() {
        view.reloadInputViews()
    }
    
    class func sharedInstance() -> ListViewController {
        struct Singleton {
            static var sharedInstance = ListViewController()
        }
        return Singleton.sharedInstance
    }
}

private extension ListViewController {
    
    func showErrorAlert(messageText: String) {
        let alert = UIAlertController(title: "Alert", message: messageText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}




