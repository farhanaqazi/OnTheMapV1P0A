//
//  StudentInfo.swift
//  
//
//  Created by Farhan Qazi on 1/22/19.
//

import Foundation

struct StudentInfo {
    static var sharedInstance = StudentInfo(dictionary: [:])
    
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    
    // MARK: Initializer (for creating a student instance) that takes a dictionary argument. The dictionary argument is a single student JSON dictionary that get converted to a struct.
    // Each of the struct's properties are set by retrieving the appropriate value (element) from the dictionary argument.
    // To initialize: StudentInfo(dictionary:[createdAt: "2-18", firstName: "Jane"...])
    
    init(dictionary: [String:AnyObject]) {
        
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        objectID = dictionary[ParseClient.JSONResponseKeys.ObjectId!] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String
    }
    
    
    // Array of StudentInfo dictionaries stored below. This array gets populated in StudentLocationGrabber.
    static var studentLocationList: [StudentInfo] = []
    
    
}

