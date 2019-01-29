//
//  UdacityConvenience.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//

import UIKit
import Foundation


extension UdacityClient {
    
    //MARK: Login function to udacity
    func postSession(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void) {
        
        // The string form of httpRequestBody (below) gets converted to type Data in POSTMethodTask.
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = POSTMethodTask(method: Methods.Session, jsonBody: jsonBody) { (parsedResponse, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForSession(false, nil, NSError(domain: "completionHandlerForPOST", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "Error Encountered:\(error!.localizedDescription)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results found.")
                return
            }
            
            guard let account = parsedResponse?[JSONResponseKeys.Account] as! [String:AnyObject]? else {
                sendError(error: "No account was found.")
                return
            }
            
            guard let key = account[JSONResponseKeys.Key] as! String? else {
                sendError(error: "No key was found.")
                return
            }
            
            self.userID = key
            
            guard let session = parsedResponse?[JSONResponseKeys.Session] as! [String:AnyObject]? else {
                sendError(error: "No session was found.")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.ID] as! String? else {
                sendError(error: "No session ID was found.")
                return
            }
            
            completionHandlerForSession(true, sessionID, nil)
            
        }
        
    }
    
    func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void) {
        
        let _ = taskForDELETEMethod(Methods.Session)
        { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDeleteSession(false, nil, NSError(domain: "completionHandlerForDELETE", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "Error Encountered:\(String(describing: error))")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "Sorry! No results found.")
                return
            }
            
            guard let session = parsedResponse?[JSONResponseKeys.Session] as! [String:AnyObject]? else {
                sendError(error: "No session was found.")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.ID] as! String? else {
                sendError(error: "No session ID was found.")
                return
            }
            
            // Only if there is a session ID (success = true) can we delete a session.
            completionHandlerForDeleteSession(true, sessionID, nil)
        }
    }
    
    func getUserData(completionHandlerForUserData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ error: NSError?) -> Void) {
        let _ = GETMethodTask(method: Methods.User + userID!) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUserData(false, nil, nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "Error Encountered:\(error!)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "Sorry! No results found.")
                return
            }
            
            guard let user = parsedResponse?[JSONResponseKeys.User] as! [String:AnyObject]? else {
                sendError(error: "No user was found.")
                return
            }
            
            guard let firstName = user[JSONResponseKeys.FirstName] as! String? else {
                sendError(error: "No first name was found.")
                return
            }
            
            guard let lastName = user[JSONResponseKeys.LastName] as! String? else {
                sendError(error: "No last name was found.")
                return
            }
            
            completionHandlerForUserData(true, firstName, lastName, nil)
        }
    }
}



