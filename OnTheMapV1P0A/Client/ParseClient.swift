//
//  ParseClient.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    // MARK: - Shared URL session, Comes with preloaded setting in this shared session
    
    var session = URLSession.shared
    
    // MARK: - Authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    
    // MARK: - GET Method
    func GETMethodTask(_ method: String,_ parameters: String?,_ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var urlString = ""
        if parameters == nil {
            urlString = Constants.ParseBaseURL + method
        } else {
            urlString = Constants.ParseBaseURL + method + parameters!
        }
        
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "GETMethodTask", code: 1, userInfo: userInfo))
            }
            
            // MARK: - GUARD: To check and see if there was an error?
            guard (error == nil) else {
                sendError("Error Encountered:\(error!)")
                return
            }
            
            // MARK: GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // MARK: - GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
 
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    // MARK: - POST Method
    func POSTMethodTask(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = Constants.ParseBaseURL + method
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "POSTMethodTask", code: 1, userInfo: userInfo))
            }
            
            // MARK: - GUARD: Checking if there was an error encountered
            guard (error == nil) else {
                sendError("Your request Encountered Error: \(error!)")
                return
            }
            
            // MARK: - GUARD: Checking to see if we have got a successful 2XX response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Returned: status code other than 2xx!")
                return
            }
            
            // MARK: - GUARD: Any Data....
            guard let data = data else {
                sendError("Sorry No data found!")
                return
            }
            
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        
        task.resume()
        return task
    }
    // MARK: - PUT method
    func PUTMethodTask(_ method: String, parameters: String, jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = Constants.ParseBaseURL + method + "/" + parameters
        let url = URL(string: urlString)
        var request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "PUT"
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "PUTMethodTask", code: 1, userInfo: userInfo))
            }
            
 
            guard (error == nil) else {
                sendError("This Error found: \(error!)")
                return
            }
            
       
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(" status code other than 2xx!")
                return
            }
            

            guard let data = data else {
                sendError("Sorry No Data Found!")
                return
            }
            
            

            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        
        task.resume()
        return task
    }
    

    private func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "JSON parsing didn't work: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}


